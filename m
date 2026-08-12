Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C75C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145A86B00C4; Wed, 12 Aug 2026 06:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CA76B00C9; Wed, 12 Aug 2026 06:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0321E6B00CB; Wed, 12 Aug 2026 06:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6A856B00C4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:46:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D2D9C025B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:46:33 +0000 (UTC)
X-FDA: 85092288666.26.F09579B
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9C0B2160009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:46:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A6yu7fzT;
	spf=pass (imf08.hostedemail.com: domain of 3BU98agkKCO4QbYSUhoXbWeeWbU.SecbYdkn-ccalQSa.ehW@flex--aliceryhl.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3BU98agkKCO4QbYSUhoXbWeeWbU.SecbYdkn-ccalQSa.ehW@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531591;
	b=jydbTLa1ZuM3kkvqSvoXYkViJtpoF5wr0ec2baLnUMtou5VdbwDP+y2lkMORnfiv4JC9TL
	+RLe/3do8xO5tCiPv99IJDUydMV5QGxd3HWg8ezDQca957V/5FyCQh5kUcEFbJgDsIpbHq
	kzsX5fshOax5yaR7LbTXIKwYtPpArFM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A6yu7fzT;
	spf=pass (imf08.hostedemail.com: domain of 3BU98agkKCO4QbYSUhoXbWeeWbU.SecbYdkn-ccalQSa.ehW@flex--aliceryhl.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3BU98agkKCO4QbYSUhoXbWeeWbU.SecbYdkn-ccalQSa.ehW@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=We00DF4+3BigogDR3VtOXvT9GTf1WR0fMhM2uJPuB/s=;
	b=nVV+glVpg62CJhAAr4l60Y3C5L6Es4W4FmR7cuYmhiZkZjaMRHN8GXxajMUg24PPA5M6Yq
	puEWAmqVx+R1AmQdN8fnt+QvgBDxBKcSwFjjgpvOVOEdH51caQQOAWIh0fRY15iK6I1O6E
	UnLpf4PyGgfyTvsAEuDZX+bPC1UgBWs=
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47f726186c4so405269f8f.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786531590; x=1787136390; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=We00DF4+3BigogDR3VtOXvT9GTf1WR0fMhM2uJPuB/s=;
        b=A6yu7fzT4USnfjQNy+hwqibZWqd38t8KS9ICLcuUeuzYMAyRFb55QuMD52Jk8jcnyS
         btUODJnPEE/sLKvsUhwpRObiVOvPt9XRQWN7/KViCb5ojK8MA/7pfQYYU9Ma/gfqODMu
         fJhf61K0/qoq82tM4oUc+KJ9JUmkjjTrPxBt3csAKcuV/Hj9+4aa6F549Y1TwBMKBF8N
         lLIrEY+8pqoHJ6BZTtZb1W5gOw+iXxTsXZQ75AbxkznLevdL7Y0EGd6sdmOGh3NNa+qC
         M7cMLYAHo39KrNT/k1WUAxIbKpT3xpibGvO/PVtLslfIkhHQ4nuJYNjpft/ffokesD6d
         7HjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786531590; x=1787136390;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=We00DF4+3BigogDR3VtOXvT9GTf1WR0fMhM2uJPuB/s=;
        b=bz3Vqd4wln6DBO6kU5r8LvBajQipYCTIp9bFu+niOL+CnY9DaMkQZOEsh3eBR+fySQ
         05rbHu2ST5q5escvHCa32wbRTRwokFqsjNGPI+DZft7F3H3yzs3n4yPRNGfGoXhcPib9
         eQUJuwwzkedSLyEbYFsh22qd/HlDwUgwDsOdFUIoc8/sTUVoL0T5lrFhjWwMY8Gc31Fv
         MP/PdUvtTpafTO2u/sDLvXiWHCj7AohDCECXxrFDxQkAwD8oz/eeppuRKXKzYe5t2E5g
         o0wcxaQD/q3h+Uqib/7XQHtsMsYQtUWRUOjyPH2zjIaJzhQdqbduuw/iJtvwXSdVXjwH
         ztBg==
X-Forwarded-Encrypted: i=1; AHgh+RqSX/+QniGqnu/OqwvcU/pnAPl5hs7JyzuhuUK3Uoc6sy3IZP4LJ03C/7i3SF6hBJiYLFf493GeMw==@kvack.org
X-Gm-Message-State: AOJu0Yy71FwObkKA+tC9Lx0D1vxtqLQTP4G2PErwQvUYEvzsQwo0z2SX
	ht4dFZ1ImrI1ujgY7uF9Ynx9q9iGvN7OCya8T3yOStDpb5cIIAqaVXJ3KhNM9mLQyDvzl1yj8Mo
	AQSJ72VLbRIUnECHlsg==
X-Received: from wrou11.prod.google.com ([2002:adf:ed4b:0:b0:480:268:8efe])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:41f5:b0:481:56ec:b422 with SMTP id ffacd0b85a97d-48156ecb42cmr208328f8f.9.1786531589687;
 Wed, 12 Aug 2026 03:46:29 -0700 (PDT)
Date: Wed, 12 Aug 2026 10:46:10 +0000
In-Reply-To: <20260812011056.902771-3-surenb@google.com>
Mime-Version: 1.0
References: <20260812011056.902771-1-surenb@google.com> <20260812011056.902771-3-surenb@google.com>
Message-ID: <anxO3VT1JPAuSNf-@google.com>
Subject: Re: [PATCH v5 2/5] binder: Make shrinker rely solely on per-VMA lock
From: Alice Ryhl <aliceryhl@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 9C0B2160009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yrs45r1suhohes3eu8fi8oabxtkztkdi
X-HE-Tag: 1786531591-779441
X-HE-Meta: U2FsdGVkX1+BLBqgP5aTX2gbcJdSF98QAn983OS09YkOX/Ae/mysgaX6cIy+1Y5Jb5P6NjFvqEvYiIsSFfUBFxDAhSxO1BatrS5PE9h7I7e663WoXWuUClWo3lcfG8XJb4QIwxJhD3MbaYahI4Z/g7oj5tHqcR5syV1O4tNilFJL467zNsSvr7Bm+OyIWm0VvgW1fka7fRpcAqx2J57cnuycWE4yZhHPGdKeMkDlJGArqTOigmSXFn6xCPZrfxb8sdtZjR7xhaTxTMz9qu+Hg8ed2LyMCOw0CuBRDkRMdeCGalxmWv1Utkba4v4J4AfWxcS0bRRDUwNaK1BBBBC7SH8CDOmeb/wOOzqg6xM2zA5VS0W/vWaxTc0ZGrjuGe8B+F1gtn0k7YENEzoLQIngStCSjBvcVY50sJNmnppotrAkwma9ncw3bSHI2AHWwQJbtcq41m4lgv+balBeGAAPirNqTiI1LmLrKNe+oL7xcSDL4Kag7abkQIPFZt67JoF0RSg2r/Hsf2tRiXHvxrOBghtnI+xDnG9IMGnKsHmPzdcD7SZgnpW5nvMxQxgvbETt9WF04lvVeTf0u4G2iXSPtyhQ59NRvfvAD37oz5slrbBw0ab5s3HB6L+k3nNwIF9tui9T1V2PhcLUMfvYIk70cCOJ5bVkdo9lvQg3VqPq2w4TnVWTIvdQng1HcCaok0/8jzV0Nm06wdtr0McsFEUBURn7CVbvVVd/zpvQLpQZjmXjfjgT0+6ZscxdeMi+GqoCQSbQGImecufyJIeOP1JNcQy6IeexmP/0DJuifsrZxBHOVHxTBlMlc2bKmsZE3pbzuyADyHVQ6taRbEwWbogW7/YGu8AYz3kI1BwaGdV6B4wMsxidWcvYm4S+eEF8P7UxyRcf4x5XV7OW8FxGP4acSmEcqt19TQjL72q2oeK4QVfiVbRX5uBagIq5TDPMEXFrF0VbTT9G3qqMaO9neJu
 J1YvstbF
 CzmFgXCP9zxmW5eYHIM2c2tvcj39mcouqtX0RzmACmM07Ph9vz5aoGWSgzSL8RDWDDYwx9WZM2KKTI+LMcYmJruSUrMD/c3YKq52Sq2YwbKovZxlGXPEZT+tHUuhoDh9ookJUEbcLI76hX/YQRJ7i8AuKV3Q27rmz38YFIEsg7KJkqJ10nH4i4KikuDg0Q6hGhiHt3GnJ9+K6Wixb+q2H8BADrxC9uTV4H4vbS/RWinN5QbGNy0TTKGLWUJRkNcm/8kv6HZNrISk24SrzlzasmqX9iNsK+5v3xNdAnAcphj/+7jA+5z2mYuwhXNGK9Uq/90UtY8c7nTxtPHmA5nrg3mOzJTgaHf3mLdMeuEeiWd/EC3SUx0/foQ+IXiR34Irue/qVakpWbQeGkjYqr719LY6Z7vH27tYzVE8RFZVrp0cPwA5RQK8SCHM0DApvV2vJwc123X4KBrJ/s0/rHahuwQc3pgO4qNBYuJ5J47dDOlgAjZAd61pU66gqBNg7iqOgIAM25I+J4LO3jPbQJLUMqhTBuuhJ6kYSBpMOhL6Z0Cf+zStauUDXOek6gTMlMod72l4A81jYwD+qVEXxPNV4IW0YfOogZAd4iX9bTKag6JST0Z/azs1MXKyU3XQRIQILtUxoqyHkdOM73Z24i/x1G7lxiVJfVfVE1qY26TlDNGqJ1QAEfhh8oweDlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:10:52PM -0700, Suren Baghdasaryan wrote:
>  	return LRU_REMOVED_RETRY;
>  
> -err_invalid_vma:
>  	mutex_unlock(&alloc->mutex);

With the err_invalid_vma label removed, this call to mutex_unlock() is
no longer reachable as it comes right after a 'return' statement.

Alice

