Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50944606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JbIz0wsz
Received: by kanga.kvack.org (Postfix)
	id 1324E6B05B2; Fri,  6 Nov 2026 16:39:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3156B05B3; Fri,  6 Nov 2026 16:39:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F166F6B05B4; Fri,  6 Nov 2026 16:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C36AB6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:39:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34CDB160211
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:39:22 +0000 (UTC)
X-FDA: 85406010564.27.2A6AB61
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3994014000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:39:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JbIz0wsz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794001160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kB/Y5PEbVuWlkf12j+Mjb6ULAf54/v2crnDAHxUqWOY=;
	b=p/VIh9zV+VBA13OWnve03MVtKCCmQ8Trv3YwyggdlrdVOnuBlFBbypCJMtfnVQTtVVtVa7
	YwEnf0JgUgqGyzhrsCCA83CTEcgBhKXJ6Tus/nfBZ+aGUD2NXzMvS+EHQIwc1t7RjgrWaO
	yxHvjoRAN9ccWE0YOgcmAWILLSi5Wbk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JbIz0wsz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794001160;
	b=P9F3bRFnjIbwlAUDyRIMh6mS4/uFhv/4VXOdfVegq89vjB75vvzdiGfcRO/8XcCK0QpfEj
	0TA0dARCljTzW/nqIHK/JGaeiaTt1UaHZ0kAlQTsEVrmQn1GgsndptmDiB9eU3QKW9uYju
	VmAmVGOE5GKD5G3oMDKQIOr+ZllVeYc=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e6eb21a8fso508181f8f.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 13:39:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794001159; cv=none;
        d=google.com; s=arc-20260327;
        b=D7XhBjCU3/o4NkQiq7/YMYTiay6JZx/P9YwHsmONAOgqhPGaUG2qRQRxkhu6qbvhOw
         J9K0CSFWx2r2n9jc5QH4OzrvFtnFwA1OFdbWggxEyeXZmDvQWIoiFSJqqL4wUu9n2lvY
         KHU4qmVsmBWTQ9gd1cfhQDnALL8hE6QtDsRoVaIxT8kp5eUeeeAGwrQc6lTaJkvEHMxi
         hH4xilpXpOvfybjDj3fgKG2tJBos2Fh31da5NutRgjrIn5SMS6XdPHtSHRx3N9huS/6Q
         0Bk9n+rXsY+FF4oYNlEoqYQGsOKA0Nvugrz1bfzEvY8DuAqjYXevmIvSPgDfh+7H9u1K
         6vYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kB/Y5PEbVuWlkf12j+Mjb6ULAf54/v2crnDAHxUqWOY=;
        fh=2ttLwyJN19FZaFS/frJTUiQjXu5wolXEuJXKgd8Sg8A=;
        b=fQh4brkWdYCftfTREhPkEnnl9Fe9sdGaDOi5LZoozYVwn5T2Vo4cW5PLAamWfwTvtV
         sIw6Y9RkS2jlx1PWqVq/UagGmdkN9/6mePQoFn8gOF9ZjKcm96CgdkY5EZTemEpBD7uH
         1J+/4zEgkQ5yeoxgaG+9UpCRHzFUSRvvw38zuwCzUsYtCYbGLHJ/ilyZUdk3WLu0vC/Y
         FZ+9s+W3yVHIKRus8rjpO+1rcgj6eHbsInbiB9owV2Xtr6cKiOqBr//IXwCl7M8STZr4
         8ksDKW8KbowOSE/aaQ2nzZqMOw9rmH3tfAxNlNXhD3rjAtr6RuSn/YJkCiMbjKRltve1
         qbUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794001159; x=1794605959; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kB/Y5PEbVuWlkf12j+Mjb6ULAf54/v2crnDAHxUqWOY=;
        b=JbIz0wszLvgWM27S0FCzz7Whwl/SPhLmXfSnRjHA/nCcwuFao1n/SOgZKyRZx7vEOk
         +AR5DUwQdRrOmgw1olVPQ6TGQ65g0h/NAwbyfv88suIhU1o5+PhSRycf/1v210/BNQqm
         N52Z6RXlFbFaHIBRyj+Sf+KkZT6rXlDFU8Lh/Jef5H+1skQWypiQYsjCDz2KQh0bPkD0
         MtmO0s0omGZcH6FXEqvwfcrXMrbGeoS07uoZD/6wTsq5rHvL9hd1MoWTC0LYzhmLbqIr
         UPqwU/KPWLqmomHUlVYeA40GmyuVPzBYMtUCfPBLp7y5rnvOJYaP4JobuFrh+NrAk/PX
         TlOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794001159; x=1794605959;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kB/Y5PEbVuWlkf12j+Mjb6ULAf54/v2crnDAHxUqWOY=;
        b=cu7ysz3yFsh0DbymZL8hDMKKnCu2FRkqb9RtbxV40qjXfoSF8AxV3VBMpv02kXQ3WH
         QwPLh0DFazmYJbhCDTXKcrntGerjAKz5H7DCNf02+pfQRvEYtLZdqxDlMOKO6LnQkJPs
         6mlU3Emg6dZ9/U2LwH+ZwZuu+4Be6kF1i0Y+gCcsPTVnocaFs3TU0vheyUe82jWHWJbp
         fm8WeHafiG2XtKCIYucaC/w6WxxEffqqL6rkdw6eRmEQW89cNKNdwxGuCzJoQjtQEBlN
         MspdyOuTyNp+aGvpdNIPp8Eu0HOSMEOnD3Woc2qIWhJDHf57TabwpmrudWi4NXbGh+XF
         tqIw==
X-Forwarded-Encrypted: i=1; AL+hErGnFs4wvZNCnLoaMA7UE3gDNBiZtwgRGk6oHD/MlaYGnhrPCgQhc3G3O8cn1jb7XaVCVTrV1KW7qw==@kvack.org
X-Gm-Message-State: APuU4Z9edk0PcOn4rzXpUVbu3NGyiQ8a0XkeidQNMDUk5OwBSS7sshP6
	Qvg+pnn+WDouABP694hS8au/FIrHRXk/B4SgwgjqUkVIEtQeCLjbKGdSf3+7xz20X/ROc9hkmxu
	0skpRo0l3mQtS/2dQf3KJdgxI/TNqY5U=
X-Gm-Gg: AYBFou2qLeymZUNpvHCAG98bxDtw834lomEpQNN8UNIdq48YTvAhk/MrHSsQ+6JQ7Sk
	0PxbBW8qtrlCfDyhSIZ1dVD9P+bzj8Da5d2IAhyH1Icp5rKwn3DuKj6v2ZssyqWVwyrmaIq9Rrp
	KKHkT5ybByc8TwyNCToDjJwtfElJznzgHIIFnJEZRCLys5CLBMFSP3Ms8YQZpBKTKtec2qoYuZS
	GcwqnAvp5qZDtBNvLIwlncxTjyplpYluammhOgu1UV/KhwGFL1Vn/nRl4qBXAjkxbm7EbAAjcNI
	5zQcjOLtIqwiqvHr9NhtCbBC3/OYNfgEsVjapHp8MIuUwpTnKdVCHQGlgRA51LJ5o/WhbyC/ZdA
	/BAAlzTnlU2rzLcmi2ly9fhEuRFOhN1T3buWMscjCNbC+H7artQ7WxZTgvvHV05vC8zGPT+WHwb
	O60TZSE3JbKk9hjWwq2aQiNtTirUcMw/Bj/NQkvgn7XEYiIIYi/xjL
X-Received: by 2002:a05:6000:26cb:b0:491:a219:8506 with SMTP id
 ffacd0b85a97d-4927863e2c8mr8399608f8f.48.1794001158535; Fri, 06 Nov 2026
 13:39:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105183940.2236717-1-usama.arif@linux.dev> <20261105183940.2236717-16-usama.arif@linux.dev>
In-Reply-To: <20261105183940.2236717-16-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 6 Nov 2026 14:39:05 -0700
X-Gm-Features: AclHuK_rJJ15J3LdZzVLEblCgM0GGzwXV6YpR5Nl5AeULSpoo84sJweR4rYNLp0
Message-ID: <CAKEwX=MUtgJCCZ8MUkiCHtZ68AndAQCk7L1Hdq_AkN7v9aMnFQ@mail.gmail.com>
Subject: Re: [PATCH v9 15/32] mm: swap: share swap-cache allocation error cleanup
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	chenhuacai@kernel.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, 
	kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, 
	luizcap@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3994014000B
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: kget7dburhkx6mdw5nnooekbtteeayd1
X-HE-Tag: 1794001160-346775
X-HE-Meta: U2FsdGVkX19OmnnraKbG+8obuIVtGWY1Btav9I6cJmg1I9l9sAvFfQWa53JnqBpqETudYWpvqzHjeCFYwc570kUN07qFPhlG6yp8vXFk0VmqZYpxJ5k9Fkxmmp1yjOcMAbunZvuoqJh6BfF88WnZBzsTqF7kw7qVyq1Fyj1UZU5ftHgSbqkMiXnN3KoI3lqVCaREQW3EcQE4jkWZOUePL2y4XeXAgp9Y7bel/QC7oRNpwXKq9edauK14UTOQbjTkqhzVW0yVuJfzTkZVF207XsOOdO4DNgTHtxer7lGp7wJ2WC6NGsMDYT+Z4qGsUkX7g96vDcQu1c/ef0H3awHYTko/iqqtzqpoe52FuFm5T5Djg+ZS3ju+3WjfBHkL8g/JmKGjpVgrJkAi0wjxF49Ef1k5qyasxCcKCYnss9MnEPq6p+crMGawTTPt/fJwlryAt+kP6cpjKxX98cN9QZ3DGIplfRtlc9yf1fEoWgY73kbAzOrcjq5YApb7y/0PPfop4M3CaQtEOHVLT+EajlS/cGkhfS5elp6A4/QggQQ4K9bLcFixxGIlR0vI0um4lu78Au1WkWz+CpL/56GG1JPJP9cBhGIfEgkiZQvGeD7gWxi7+AKI9xbFTglcpeN3CVy/cOT+wNlqHIvEh/+rmhnXNuXDNGlR7cQracUASn6YZTc6kDK6CJQlnmCn0k0cdcq9CkPGT6NDMsxhAwhz++ZlUIBLQCcxD207Hy++8xitNwW/gYgfWuwg4Q7BYRdQmF4o0shQDzn16f9IIUo/jxEnyA3OKFxrlHSdUgC7jaBBx3a40ww5jwE4I1lSRnWJRCv9jMOhHt/rYtXgwn9UjClV0a9UPcSmaqWAyec5smwb798V3YXON38xt6ChJNakkiZrrL27x8TrJEJgAPMxMdOp8EoGjL0Ialt7zufoBo6qyWPuJx/CHFsAnEJoeNzkMgEDg3llKJasaQ5gdgbAPbs
 lwWeozzC
 XiLN3cWs6f43ENx55dvJspx+OmPiFAhNjpl1hNWO3g+yYHEdAm4AWPolykyo5MsG+d0JspqUCe1SbLZVk0hf6jb0GzF6EVEEg4H6DH1JXc10+tx+tPYFbn5yTIlKIJQxuQQVrZVOUzI3r/Qt6CNEYxsBwxBPTUQBdzM7bpf6n1XWH9LxiUk4FmPVxcNAjFgcPRTaAGEF9AaTcGG8m4U0Dto0juf9M+TzKDP5Uq9Tm0lYrnF84YFFT/ziOCOIRvqzKQ1YYqakL0ZxDq1z/G5pZ+1b/A1tCnSa/xGQeaTPFa2MnX30zPmCZ9TMWXmXM2H+YU48mqF9n61hOqL3su9K3QV+ObSStU0TxCGDLsyt41gmspILuiSPjKh+5WeBhyHEPieVVnzWN4gpmBRptt7NtcdoV7NFYM5wRBaBJ6Lc0MuGCSqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 11:41=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> Both post-insertion allocation failures remove the folio from the swap
> cache, restore its shadow and drop the folio references. Factor the commo=
n
> cleanup into one error path so additional checks can use it.
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Nice cleanup.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

