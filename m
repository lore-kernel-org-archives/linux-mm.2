Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F48BCA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0196B008A; Wed, 30 Sep 2026 10:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470E76B0092; Wed, 30 Sep 2026 10:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387286B0093; Wed, 30 Sep 2026 10:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10C416B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:34:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89B5E160820
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:34:34 +0000 (UTC)
X-FDA: 85270674468.05.FB8AD6E
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf15.hostedemail.com (Postfix) with ESMTP id B72E6A000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:34:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lk9e9V97;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790778872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WbMv3YGX7nMfLppnaRbgidczcJaf5jYeQSivTTiMGs=;
	b=26IpFMLGRqMzVpnWHLnLtEffoZ5AHEhy2vUHXOspNo1kEL3gnPg/+YGwrcvI/Z/ONTfLwZ
	VXZVZb18hQYN2o40GIsnMx2r9ymuAXe0f5q2oNpJHgiHiMFTe/bLUkKp8DjqDykj4bsuur
	RbK3OexUjV9yg72BkbZ9qBWMHc+jC2M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lk9e9V97;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790778872;
	b=p/FRIuLRup6eOuZWtGiOltei3ZtKH2tJltQNGllw+V2L0Tm18GR2AKOwTliTCGZ+Q+yGep
	i+HaTbvXH6265lfhKSMgW9a8lTC4PEgT0vqP+mDWWw+VhzVONvdiabc/iEFZ+9njmKyIrj
	+KthuK+dJzhJlWaTW7mIKIFsgfKIUo4=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so41341005e9.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790778871; x=1791383671; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9WbMv3YGX7nMfLppnaRbgidczcJaf5jYeQSivTTiMGs=;
        b=Lk9e9V97A7/YsJo+QVGWJLmXBb0OZtVvjxw4ppXWRBzOxlX40JGRFHiE5f2uZ0Gfoz
         JWKQvzt5KnLBCFWQ6k+GyJnjfzN+yF2BEpbp3uaOHdVclUGOIKm4CN/MI0JUqSqsgop0
         a9rv4XlgETZQ7U5Ei1JZbLXAp9E9K7ZxhYeQQZGYc/PjxYTTX79bK2f3rgyu7lKtTySr
         SRp1R7CB+WPA3jj19YifA0fH1mtOy1GRXC9lNPPLmrTUYg9NoVjHrjDktKX7/9zg3C4F
         Q7XIA39FUDtXOjji+5A96oTWZa9SmqXDQQ/8FyUdbPBjoRFejaJH3dMXh7jtk+ly2w+t
         GQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790778871; x=1791383671;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9WbMv3YGX7nMfLppnaRbgidczcJaf5jYeQSivTTiMGs=;
        b=c2s8HrYnrzRuBQkUos7waZoxbmAtd23oHBgcCyhzLL/i+fDnyYKZHfftgRE255ppBv
         bkOaSur6iF2k7ATwH7AVsuK3zkNuDJLAYcibZ1h+Lc43ZCyqQxioRJFO2PnqJcXeLZCv
         EAGuo47NZ9HpyWdqLKAgagn8BwjvHp1oNOPAouizw8bwoIzwGE/roseV0RuFxeAygxhN
         rLEWscx+yTaaWFgbENaezY7aA0DRhMUqX6IY+zlQGCsYr9xdTdIF+kxOab4sJMk79d1V
         WxM/+5zqPh2lG27bcKSSLTppj68hBmyNK5I82ex0/Xe0RTgRGsTCx4/51g/58YNlKmy7
         V9+g==
X-Forwarded-Encrypted: i=1; AKwUvBxoRYxwahq9xcsEksOLw7TIc/GZwBOO0h/h4qQc+Wu6iUJAqvYDHf+GpmXtm+CXcGo5Bk0Z2yj8OA==@kvack.org
X-Gm-Message-State: AFuF++k5gGROECrP1lKElSpsK1CmKDX72wo3oLzYx5dnz05DOcCv+/E4
	XhaRMYRLZp2HCLokjJHeumOxCR/e9ZDVx9LAwGYFtjSKRYtcA/vVbSZS6idWpvPA
X-Gm-Gg: AYBFou3eFkZVw9wr6rjbjjTGuy9iJa7WLuxjjEMdJVM5CBxDHKO453Lm3ei+EPXptOW
	qzlOiqIM5NuC4UjyN5TfvAw7grpzZe+p0f4r08qGDNlYfq7zlx/+W+VhxU6tGnu4jRouCGWETWY
	EZ0DS7Ud4+OfhVyQ3S7DOcNn3PmSS/l47lr+yqcPBWtIRn+PGx6g93TC+xSUn+EOolK8Q1/1XR8
	sTFmIAKZuE4YvHs60tsLKY1yPkfix0I6CGQsDM0+NUdOEvf08DYmR8F34nm7hYc0Vtod7M4+MPP
	YKhnhlckxT9TIf+O5TsFOyUEXsH4XHBeBIVJsQCouIzLVwKCWVHkjZDXGoSlc4hgTWj5+1zEx/d
	ZXxh6SXPMQV+GAGP3A1lGKYfgBHjnDASSStmVBHBZIcqGMk8JpWgbmwn4iW+9YhQj/OA+c3AETF
	iAyLylYs7pPttXpotVa+zXqpzq4F608jEzAE8ee+HGsNCf74GIbsVEIIKnZm4IeRxKBwtU13stE
	dpk/H4Snm79WTQ6Wp0MkVMg/DCpXWa6U0BPvYflHcngdhkiuRxlq14=
X-Received: by 2002:a05:600c:1c10:b0:4a0:168f:d962 with SMTP id 5b1f17b1804b1-4a01ad8f2eamr34710865e9.3.1790778871080;
        Wed, 30 Sep 2026 07:34:31 -0700 (PDT)
Received: from C422HJQPQG-Fractile ([80.87.19.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01e42ad94sm4577045e9.1.2026.09.30.07.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 07:34:30 -0700 (PDT)
Date: Wed, 30 Sep 2026 15:34:21 +0100
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	stable@vger.kernel.org
Subject: Re: [PATCH] rust: bindings: fix VM_MAYSHARE blocklist entry
Message-ID: <ar0d7Xl0py6plis3@C422HJQPQG-Fractile>
References: <20260930123645.302318-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930123645.302318-1-ojeda@kernel.org>
X-Rspamd-Queue-Id: B72E6A000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6dhg5q6ziu8yht6k4i3nk3941c63r49j
X-HE-Tag: 1790778872-778839
X-HE-Meta: U2FsdGVkX19OacrjYLN2Th1GyrqusLpVNnDFldeMyXSaYh8eMaiPLadk4Ol3NtbxXO0VHRAZRxF6d6JjdidzGjnvHB5GZPt1BIox74mUvuYgtk4PJAwbkiw8h7xDgKgCxc6u3oBMFjLFQWB64KdYjhd7RkjpMH71PniEQWL1buMBx9oaPj9nz0pJPsPNos12YoAhmEEk9jmJvP2UOLdZTZEd6alvH6jEf+ac95yJzwUAHz0nX3JeAEP49Nyw41PvIcnzrGjEqS5av+Fud1Ig64yW1utvG7UhTG8KC74P/ADcP1ladt6j1xkkk1ZIb5TpQ+hFTgNfILF90jACPhLnsOdS8B3TB9f6BT8U4wCitO7Gn1LSgGLZslWT8e4WpVTSIQQipmSDAzZEHy1ZPHjmVhL4BfLixkJ6uxiGtP+wYHbGPKGWrHAgWX3IT2yfK28Oscv0OJ60b0EC8C4y0btUeU3CyXKmroeISTgRLA7GkZWYLizAu84AFocF7TmxYPJL5DoosN8UfeEspQP0JYUyro7rpAFbV0b0b9N0QgIP0Rq8yWTJSUk8rf92GgsxvxAvqsBjipRNX2UxyadCoQJXlq22haWKD9+/c9po4E0puKQ0Lt0O2nCA4Q/c9NixVn5cNhTDfFqR5YVq4rsRhQcIhrSYnrakEBUtCylMVn7JN6cp8lfCl0e+mRC1sH7XhWTxIRuiYb+XbwlWN43iM/RvjDReOqya9HtN0b9FcQzUwxLGGp/kHndc6aazzxDH4ALJuEceAlX4ixA/SH7142rXlc8SyorxwtJ7iOr9liyzyQz5bjgJ45sl9z3VtdvhI699GzV5XRWx3EJTqJbpf7//JaT1JJ0iriP7NkXUE/5s9I/fgQFx+jjmXHyyCaBSrr4rlK23aNYz0tdgXP6vrxMhCDswlW2eL+rvg4DoKLrT38G8PlvStVKDHTOpl1KSH1rDzSa+dxLv3rfrtRQw3hx
 /bGLY7P0
 9aX8ajYZ6YN/odO28BcdOhGOD2z18miYhMoKu+JaNqXvN0GiAPl3EOXuyAYkquSVPXtlceA40oVXqAOKc5E4ryhfeMwq+jo4xeV3VqZvKuCIIHs/bK4RCBggwxwChb8E18heAJoRTlHGY8WPw+9qO18P6GUnPP42OejlPfLaR3EQbzxLZMzyDSpVKbMVVuPHf0Q+C8n3qCSYKONwJoNcLrah5/QJQPa1LIC9UFEtG4MCGrVJ9qGuWcbzoaY9oXO+jBGwoUUCK28T3UDUY97lokKgeqrDuGvP7Z9UAwZBXzUXIdJVARJ4BcAhh0vUBKekiCnTFuw7VecQPbqHntKJVzIz6ENV2N7xX7Pt9usvePcvb+9JHNbERZuSJvVaEiXj5NQmldJhRfLDMrlC3Q8NuBSDxmkxLFg/dju51XwSEQd34FOGaliG4KoQnDWYYz2s4qT5Eq3ZS2stWJwbDiRn/qmqukUZn75h5q98wJ/ejao7OVRI66DQ2syJLCFCIFD6h1ot3JZ01yEjg6ieqbCfVyLJAPg17bSkgIlD8n9qn95IKg3A+vCRtxQUrwzHzr+NIjy5j7yN0bThYdCoV/iaWDz+2roYUr26GmmRf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 02:36:45PM +0200, Miguel Ojeda wrote:
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added constant helpers
> for the VMA flags and blocklist entries to suppress their direct bindings.
> However, it listed VM_MAYEXEC twice and omitted VM_MAYSHARE.
> 
> Thus fix it.
> 
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Nice catch!

Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>

