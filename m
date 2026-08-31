Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E855C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4696B008C; Mon, 31 Aug 2026 07:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C526B0092; Mon, 31 Aug 2026 07:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4116B0095; Mon, 31 Aug 2026 07:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F047B6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:13:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85CF2C0439
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:13:56 +0000 (UTC)
X-FDA: 85161304872.24.4AA253F
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 949E140008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:13:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iNyWZYHe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788174834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuWjbx1O5hIe3EKGR7TrgAX/AAbp43qDAxNhOzFObuU=;
	b=2fgU1i9WFRD5i/r5agnS17kVfL19+9jULq6766wP21UqPUInNgY9pssCLTPaXHt/5doEmD
	vcDz9kC2PyJHtLGO2WUnfO8/FtowiOBIU6eU3P9SWq9BCDBm92FYvHPMxHy1ehTGas2J/w
	s24+Mxa9wJ7bJZXvnbl5iFRFC3NuUVY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788174834;
	b=Fset1ae79TlvQ4Nhblnj7QUVE2Bswl10/ipQxaRxXnIbLuystAC61WKMhrcCVuCdj5pOw2
	OsI7SmoZFbHtrWZpIHLMWS/rVB7thoADdrtHx0trSRwqAzfMIrrzthhB8U51RHqDG8sIYk
	uq5oE61YqbMIw/QvCA4LxN7QHLzNbsU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iNyWZYHe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84864086bfeso3485723b3a.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:13:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788174833; cv=none;
        d=google.com; s=arc-20260327;
        b=j/F5sGxgZjOpPmtxTKzqx330eyYWZJjhuwyG6ehl93roQ6oblbYXXk5yflUG5i5gIm
         +CC2p+HZjEPbsvIfwbwtvULYdK8UcpUIGGqsuOcMJ8QIXybxnn9+XxfmaxEOBycG1IZ6
         9962cIT6ox1vHy4NpOeLih9bzM9/eVmDElffmjJnepVVXtDHhWwX3kqzHxvgJVDL9aS4
         03KUNmhQFmSjNBCk4rrWrsG4rC2afnuAxJOTPCOlwS6euIk6TDGVwiMnjwjGG8Qvtmps
         AFDFb3P+4MTdm54M1LBC/0CRpzlb/OBb+8ZD7HWE0Jn9NRWjDZbq9qufwhl7bujFRLiK
         Vb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yuWjbx1O5hIe3EKGR7TrgAX/AAbp43qDAxNhOzFObuU=;
        fh=bLjP3My+mdYVC9dZ7DCghk44tWTn7VYzYrNUOyCZ+n0=;
        b=kySc7uY8kK9ErWyQlWHjt6m4UaeM52NuwluM/c8sZRE+oUuGcbAp/1zzYZ2ZDKKu+N
         n18J2uEnNoKpwqKWuI0ErasnQ0hivnbWuDNGamU72ua+uLwKqhsfdr9O2F6xNZ6IYFLF
         L+wikzMgdr3O93vfM95olF25vNhh+VC9JWPtum8un0fEo3BH5XlIIGSaJsTEBm5a7MdQ
         DLNzDa2oaiteIFtfaL1oTmzZv4/sHAT59GWRAS91NGcG59q4EH+cfBUestMXbGQaedSV
         2ZRE5ErnRX2x63TJRplS3JIMozj4gDCSdZf+Fnzpkgn2fFTA+RT/2BqWIZ+84wgMNMJW
         foRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788174833; x=1788779633; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yuWjbx1O5hIe3EKGR7TrgAX/AAbp43qDAxNhOzFObuU=;
        b=iNyWZYHeo7wRCoHy7hU3t0PcUnPoL8EEColFY2siNd+/TrFd6ASyioCwLGWdno1P8I
         na246k1Zjt4jfDpdlKpRWQTcSosFPxIurR1UHiJ6jH3xEOijWElaC7FF8DEEgWPnMUt5
         rs46nvy/JGS4qr+ZJxPJ5YW9WMJEcXZusGgh8kYtaE5Ue5gH5Og3/MDFVOVUaBzHvikD
         5oqiQ9wrXSO8hYNJRzaO6RasC50B7Gqf3i8f+nVy+LJqKyKtWuHw0BVRxNVN5tL3DY2X
         J/lK/GJHKFA1pHnXQ81lffl6uKFN2S8gd3PO0ZNFlMLorR6ay4GC/x4E3OIijttlpQhj
         O4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788174833; x=1788779633;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yuWjbx1O5hIe3EKGR7TrgAX/AAbp43qDAxNhOzFObuU=;
        b=DJno8X0Q+xay+28RfEs35bSkt6n+lhQDcEoQWtcz0HXvadPaUc3LRyBjFNY3MJ/nvb
         OboEA9r8l8FDoX4qQXVYhHWZ7k40GWblzfRPEWLf7RIQIpw0pNNQYKM5TtXC2zX5sk0B
         2N9WuS/p5pBaN8OgrK7Bpj7dDW/1z9JQp+o0NNxs6itk/PJSEJer7uUSyVohUEDKZvy4
         ZhRR7aSAzANmXbCc4t9PuPxm8KlygYJ1hegoc2kbGT1cm/+xdSKK1uapqNRWjwgyhV95
         qy7eO61Kg8XU1TGhSygt5huZ8x9CwMRZLMGagNu/jIb6FV0YX7O+kjlVPrTEvrno51vA
         c8qg==
X-Forwarded-Encrypted: i=1; AHgh+RpcsVDn+eWtTVMjvLG5YaQEu2utbzrIwkdB+UUthB+TNqmJmKESapGfGiSYC/h5c/2LzRTTfe5x8Q==@kvack.org
X-Gm-Message-State: AFuF++mTp6ilPX8rS8K7EkHyVTE47vyobyiDg0wDg8f/yo1KKTgFU0eN
	Z1ml98wskxCI+y12wFN/+xZVI6EQ9bfPDK13iP9bSgHUDrkKmw6vCkvRApndSaM24A1VQMV7wSv
	7nLyClRZW/EoWjyFhrgHc8FrPMyHuU0c=
X-Gm-Gg: AR+sD11qSsDLCJSFFT4/kJa0I/NT6w+axSy69jS8qfTe4cXKepHh0yq9C84W8uhE4a6
	fN/mcLmRF1GA88YcMfPWHKXsmNNnmFdbkSaf6+u/y0m/zArEeFH4Crrl0N6WnWo9lKcJ7PUlsEe
	O8p7046mPCBKSkAPhgzNFAGd27rGM5NCAxDIHrnhHiK5gsEZm4b08bcuV93KZgjIAh//xNfeS4c
	COQ2c2JYqaJlvmLcFeigv9OsMBKJ2w37FETjs9ee/dU81oT/HY3KailUT3p1OKYCCvYA9o6p8lG
	KX4GWlwLiwwso2JsfN0we14rmZuOyi4sRJbWiXocdq5B6ZhQ4F2B7SkwU9AGmmTnSdD21q5vtqv
	WtA==
X-Received: by 2002:a05:6a00:4b4e:b0:857:726d:2e97 with SMTP id
 d2e1a72fcca58-85b5c0e42cfmr426775b3a.20.1788174833315; Mon, 31 Aug 2026
 04:13:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260828191433.3304458-1-nphamcs@gmail.com>
In-Reply-To: <20260828191433.3304458-1-nphamcs@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 31 Aug 2026 19:13:14 +0800
X-Gm-Features: AcwNN1VrQPpiBb-m8M8cbBhiD6LWslgKbMuquunerrwCU6jvrwuqE6JT8Cs2Vrc
Message-ID: <CAMgjq7B9FxSU13_vJH222_wp4wdA_n9viy+MJbd22=YfgP7mbw@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real
 usage count
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, joshua.hahnjy@gmail.com, 
	gourry@gourry.net, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 949E140008
X-Stat-Signature: xamw81h1rzjphda7xpfydnxgw7kbkrj1
X-Rspam-User: 
X-HE-Tag: 1788174834-332905
X-HE-Meta: U2FsdGVkX1+sM8mVCXc/EycFl0Tpu5yunEuZYy9c0I8a/i1YlnH0oj6Ug9hfE2SSYzjpYDoh1yX29a5JqIAYdN+9JdaNajO+PiSBYHR+N770VxXTQaStGRKXmTV5v5SJPMDWcdQP9B5FVwq4ucHV3boNpyFV4FZZJjaJvl1gD0AMZvTuA5lJABCcgqq2nhQmswU0PjcYntzzH5iB9nNC8zAteheVHkJxPpGeN5bhYzGobAos7RDURZn1ZSUKAE58S8jGrmZVmcBc6841rtb8bHlPP85rGobn41Q4z/v4uw3YPOTqpI4JkZCybUY5+hALV5g9SxZqfn+mCCM4t/hHsK3p1ZgekJHraxYSQTIvwTF8LFQ//F85K2JZVRcnh5XYbFHQ7zFEQFPF780FOMIr7r3G9wQXF07Zs+UF4saeC7piDtjvWm3G5RUXdPdOM815BNRg6Yi1hkK9TKxxb2ezL7XiBI3TguORlz5iqZJqcmUnde5tvXFuGb6V9wUQ8SpEWpsrWIKYqv9HF8N11+vjf6k/FWSYNdwI2q1lwi8UCCRxegAIqGmYO+fIjgYB7ZAqCNKo1bEbIO+2Wr3PHvc+Fd/6aLMOjJ2DXvqv3gN3v71C3rconxaMIDNN7ziyGc+O5ajEtpFmIO/AHmugExM10YJ0KKsVipT+2+Rg/0UvfaEZQdOCGCypBj0c8UQmzMwcbMrUwPlHkknhh0hbqcWSvYt0JA+H2xV1MJlPazHihGBsrFQLHzg3XHi7OLz1p/dU6U4mNTOUJ5v8qvXPK8pzaejJe3m7o4nG2W+PTbPcdDWBr3/a0VyX384TGLIk9WTbNSLd0M7qoZygNQCJNQprXVWnqgjdsEM0GQNzL5g6K7zR7HtL+H5g6BjxTl5BR70lZYTcn/4TANahHOlE1lonPCfPPTIDwLzesH5anhAywuVXf6vjn57bIBvaMFAlgXsrmBIaBidTyuCsqkBp3MP
 E+OdIY3y
 bSenZGTRseDdO3eZLLDvyLDdRPCUJSVsaXKke1ZVlK1HWZ2u6QMiRQ/qKIazHxMpkf2PbJk2LoH7LBUSa2GCE51L7AuQfP2I2nKoxvf1sujcq+13CHtGJTesWoUzLyo33EvAKVVDaceaWKOTZtnZ6kLE3x6MlU4UAWZBkgqrY/ijDIxI2ZnKlTHm+nADPUNQMxuyz0RufbWb+evKEp6ytyGgy6P4DDR7TBVBMBddZ8qUuULHZdrHfxC2cuqAuCYJVXUmQBSr0Au+DE9Bt93ZHj0SiOCc5NkFEVBqn9l5lPricKKR6o8miIzIOtYYUY4wFxSXUcPkGFho4G19dU9DzBs9tw/aeZXnure4/j86BY3S/4S9zTIJF5XMMuHQtiopTWg0eO+kXAYEOFeJROD2XyTK6eNk/30i4hLgtMput6fnsoMYx7bCU5kjt3uB+Bp4DJ7/vLIaVHfFwgCuffU8n3abVu5SKEYfFUKYICE5jGMmCVagE/05EcvX6TpOvkkzX+rhMlmnV3GnjxX0nxrqT9uu7qOqMzr2bN3wa8XkBoSzISgx9FDQiZt1HxHv2zGpJEo42Hcdi7QPpllyepINsA0xeaT1+K4x+aL6kPVdQRj4iPQ4FFtucJe653Kh/H5131sADeuoQ0riDR1rplAHEr02j8hYnFEJcBnkWAjDB0mS0i3BoDD+eQKwmqWGsYRhFMHS6GS+p8wa8yrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 3:14=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> SWAP_USAGE_OFFLIST_BIT is embedded in the si->inuse_pages usage counter,
> and is meant to sit above any value that counter can reach. However, it
> is defined from BITS_PER_TYPE(atomic_t), so it is bit 30. On a system
> with 4 KiB pages the flag collides with the usage count once that count
> reaches 4 TiB.
>
> swap_usage_in_pages() masks bit 30 out, so whenever the real count has
> that bit set, every caller of it reads 4 TiB low:
>
> * /proc/swaps understates Used by 4 TiB.
>
> * A raw count of exactly 2^30 masks to zero, so try_to_unuse() takes its
>   "if (!swap_usage_in_pages(si)) goto success;" early exit and swapoff
>   tears the device down while pages are still swapped out. Nothing in
>   the rest of swapoff aborts the teardown, so those pages are lost.
>
> Independently of swapoff, the collision also corrupts the counter and
> the plist. On a device in normal use, a free that leaves bit 30 set in
> the count makes swap_usage_sub() see the flag where there is only count,
> and call add_to_avail_list(). It clears the bit with
> fetch_and(~SWAP_USAGE_OFFLIST_BIT), leaving the stored count 4 TiB below
> the real one, and calls plist_add() on a device that is already listed,
> tripping the WARN_ON(!plist_node_empty(node)) in plist_add() and linking
> the node a second time.
>
> Change the definition of SWAP_USAGE_OFFLIST_BIT to be based on
> atomic_long_t instead. Note that the usage counter field itself is of
> this same type, so it is still a valid bit.
>
> Fixes: b228386cf237 ("mm, swap: clean up plist removal and adding")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260825153238.2695446-1-nphamcs%4=
0gmail.com

It's really nice that AI can help catch more bugs.

> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  mm/swapfile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 53bf01d5f7f1..601979b97f95 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -156,7 +156,7 @@ static struct swap_info_struct *swap_entry_to_info(sw=
p_entry_t entry)
>   * This bit will be set if the device is not on the plist and not
>   * usable, will be cleared if the device is on the plist.
>   */
> -#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_t) - 2))
> +#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_long_t) - 2=
))

That's a very clean fix, thanks!

Acked-by: Kairui Song <kasong@tencent.com>

