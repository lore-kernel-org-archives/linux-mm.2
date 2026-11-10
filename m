Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9895860A383C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DWv2pYVX
Received: by kanga.kvack.org (Postfix)
	id A70506B05B0; Tue, 10 Nov 2026 10:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48036B05B1; Tue, 10 Nov 2026 10:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9377E6B05B2; Tue, 10 Nov 2026 10:03:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0AD6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:03:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0A5D1608E9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:03:30 +0000 (UTC)
X-FDA: 85419528180.08.C4A358A
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id F41EC12000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:03:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DWv2pYVX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794323009;
	b=UWw5xhEM1mFY7qxnNhC+PeYqsE1t9+nSltMamSiuH/+8YkSEcWYTBRY4rqjsoqqT2cYfNR
	B5GQZPl/IJxFdLqQYgkFYWQ9fk7knb25sr5s45Gz+4nYb8RVX7ViMuHlEwCjf36BDu6mCG
	LYQsNSkxAxlF6dt+iCnxJAKi3XRYZV0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YlUiTNXIMjlXgOTEsBKhouLB5i+QwsG/rXvMprRtGXk=;
	b=z81i2Bc44/xTrHPg2/XTu7myay5K6NJZMGqWs33R3k2VCVkflqM1W8xsrR5EAKe5SViHpW
	vcmU4v29dXP+yDMw42xefHU51CrG2V27aJGAimfe9m/8rrgk0W2wadr6mjWLLu6jIK2n1u
	bqA5HRs2z0D6uhDPdvhL65fl2l4EqyY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DWv2pYVX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3ae0a5c1715so6868941fa.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:03:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794323007; cv=none;
        d=google.com; s=arc-20260327;
        b=oYPFQ2pMh6FfXbbJGAPlKicDrk85CPfFU9ME8yy4nlvRzjQD8u66CVmPJLImTqokVv
         s8psDi+RDzZj1jwG9kKr4YskAwclL2+6OBC8rv4ozqCOYE4wbpUWnOXVcwzH+fLue/ar
         Laa53KzPFUa67azcI+nk8YDchUT2QTtX/LXgM3UnXx4JOcU31C68/OajyS0ixOwZBNzy
         ZpR8j6hgmXl/rtjBwDZiYCncq+70ouro8taG5BbStBzzFoYwjEDzy2qtJSsuKGF61sEq
         LT48+9AvP4ETse10jSN9XhgrERUgM6n6Dc4UEhwy4+2MbQYcvT+0XO86tnDYPttDNLAS
         YNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YlUiTNXIMjlXgOTEsBKhouLB5i+QwsG/rXvMprRtGXk=;
        fh=/UCqBdbtI4cnoG2le6B7qGtyTRZ666kK/vkTr6eyO2s=;
        b=nih2v48RGLDQYlhEBlActznFPe4dNsiVtidSCnU+IGHAJHinzVwCbhe1P9v11P0kCS
         EH9hovFQojHnt32XDdFwqfhbFwgcGBgAvHhUXvf77xrKGQmgAFa/x4TWs07rQZy/2/mD
         CIJH2ZBGiqq/qpKNWaVU/cH2Q0q7XHSggQDDVsBLN6MRPGvyoytVlHnbytd7RijwEhGQ
         y1TqEnUuWkdKJBWItqYHfW/8T2W/LsgvNhOJriAZvHFqeuFVRBUOOn1R8OTJtANhTD+C
         dqAE3yuhvJJCqdGu1Vhhe4+HCmgONe7OsG9x58qJGgvQ46B7rsdiYaD2/kWR0UWxPBIo
         Fwlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323007; x=1794927807; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YlUiTNXIMjlXgOTEsBKhouLB5i+QwsG/rXvMprRtGXk=;
        b=DWv2pYVX0zChYHCtlRoZt+f6vPHzEvHc7GhIY29tMp6PmGX85cGTXldazkiqCBRl9V
         fc0UTrvOCwnOWasIZ+4GEgnVBu8B4cCW4My9CahhyMZ4cH6xHznJjC9U8jwZ4Stp2WUc
         deSKmUbGLeMOeN3UcwjxAhHK2uCfLZkww4cvC/jGdpOiL5NXXhJgsoQ/7AlAfU7AHzNY
         UL7bBEgE0Ds//NIaFwmg9LY/KZO9kIf+eWae7WIUimLSitY60A/dlyzE6Y/c84l/L2IO
         2KZRyVnOWX/7DEN59MC+FGSj+l5dM+5qdFHa8b2EEeOIAbUpa6UvWY9NlEBXLyOoOVpc
         gwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323007; x=1794927807;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YlUiTNXIMjlXgOTEsBKhouLB5i+QwsG/rXvMprRtGXk=;
        b=PfnoW6JYFOx2FPw55uC1vTa7NlwiWD6sDbAltU/gvZd1qL1xMtBlDQ8fX9Ct3uPOgR
         RKBdlT3FoRXwkh7fY5rlly7OQZwXE3gmsgy3MytirgkZShmR3rbupgUYhXsmRsk3LiY2
         6ownv5+6l7T/bo6M//nI+/jA66SMfvWyMrjijLtKUsrr95sqy2E1hvwC16/bZaGO5X6E
         CV6BwU8WSsDOpcYHBTyFKcP9dz9Pekn8zwOJjGsfyGa2HdT/b7uCmrBO1Zc3/eaWXMqQ
         qIobf9cLyXmmF0Vanob+dgFkqWdm0BTpFzqeJYVHu5wYC192Lwg9I2Vn4dop+VgNjVxa
         6hyA==
X-Forwarded-Encrypted: i=1; AL+hErF7W0SVVWWlzg9SUrk1homKc1s/VltKQpeNF2rTLnTFuUvFEbcH28gHgm0Kly7bjx3N0GYolgvx1A==@kvack.org
X-Gm-Message-State: APuU4Z/ObvCryYdiBB1PMMDieSd0PiouFLi8MReIWl6arNjZl5qayY7b
	cIFuTJbe4vg/0MusB4ciWWfYmdiK5QZF+iukhPMq3zb8vY0mreXnIY9fWW9OM1pEym2uCSo1HlE
	58CKDYxL5Wl4rbv4ehTul/gRRUyr6BdQ=
X-Gm-Gg: AYBFou1YdRkiaqamNbuA9iuXDWQiv2LvViyy36JgUNEYV5IT+4WTcGSchbldBmc79rU
	IDxp70Ew11qHkmgiu2x6oxoDFQHctHM6KhpaKq8y/HkAqkVNxvL2BT2KYt0GYLY6SDUEVIKtD8r
	6NbrbxDWIHg5gSOhoyZ0SDfVjFh/1PTm/irClVbEh5ZAuQc0ktf3rHfxWH8qhnGQIKjkgljqPSb
	0lgyzdrGZ4UfVzWWybZm9O/wNf1FivvMohAQY05UR4lw29qUTTSoCa6nPFuSl6sVzwiRaH8Ou04
	k2jCCoL88CiEgdufnBxLw/dJaeihL2OOv16YYIcKSpkCF2O8W+t+GFH5mT1yL7al9WJ6d5Rwzdg
	g4r5knHsxZxTT5ZQKZJAW8N7Q04kfR5+OoVuuQFe8cGLb0T6jtjEgDZIORdnKyB2yUL3gg2ywX+
	dwBv9LrnJ8cS8leG9xA9OQA5kMg0VWWO+I68Vsm9fpqfUz5gMZR77S
X-Received: by 2002:a05:651c:2109:b0:3ac:43b3:d926 with SMTP id
 38308e7fff4ca-3ae096294d7mr5021961fa.8.1794323007374; Tue, 10 Nov 2026
 07:03:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com> <20261109-zsmalloc_stat-v2-3-caee41684aba@gmail.com>
In-Reply-To: <20261109-zsmalloc_stat-v2-3-caee41684aba@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 08:03:14 -0700
X-Gm-Features: AclHuK8U6EjSJrA4lsG52yvDTvd52iwZkoWxsdfsxr-TxwaKQPnCzHoNe4WNlDk
Message-ID: <CAKEwX=NEw=T6xWuu3Pv+v3Yh1BvfkGKRj-Xd3xxn1Ci_fkA9AQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] docs: zsmalloc: describe statistics with CONFIG_DEBUG_FS
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F41EC12000C
X-Rspamd-Server: rspam12
X-Stat-Signature: 8wyd46qbiq5e4n56crpidg9okwti5uj8
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794323008-945759
X-HE-Meta: U2FsdGVkX19+OHdsDqVlKD3VLBAIA1PBMBCW8edfLNd94rWOxB9TR7sO7Jdt+f1TWAOLEzu3n2tX9atLkUFnP2Azg+ucTEhQDk5RSF1T8gjJF1yEI/twJqucP32n+WkLd3Qyx+kqC9gu6bStdEzHtTBO3yMCswdx4ReSxQRw+oB4gCuCc4FZK4ZFQQFFyZKs6ZwDvgBoLP5mSyfRp8nSMlS5mgujwVHzpvUnThXn34ptO/S7kVxDPIv+Zkq5edkfzH/f6BNp9gssPltwUbUTAnclEi0WXR+eYAbsQ2gyBiLBd/Q65TzK29polTH6VOSc5aQY/X2g2T+F7n/agQbq08tVTxAkdSmJ5w/N2a7PEuTLCKxA06usBRWypUZde1rkolZ1ApXsFo5IAvH4zjbx+xEy4Wh+c4ZPa9md+WybvU0DPIZvzjCTTClQ9u3kBRb2vjWPi1JBUEcf59C2NQx4c+81Tx0I6Am2w1ENmy9JnmsVAYCSGBtuHZUl2VABlGi9CD/uUDK2QDOYMG+riUZ98Vgur7j0PSxi5XBOTXEIy0yghbuYwXGx1fBxxghyBE3ZhfogNDfgmNVCMP5HuFRwQircDdefEJf+7EeKnFnOcVNUc9kr7RTc2lxAHbp7nnebDmS0OxljuC1X8gv338JNdK0vpFYYY+7z7fvjXnVFa4weoqbIRnIRjnj13G6gsQD6bQFnd21DrIankG7AVsy8wuCTXtjIXk/rXDmKek1uSo3It51ZMu/thp9lA7Mbc61h7BqWhn3yG4peTeNDAEw1GuVRn9P7rKVCCsxU+XQiBY9pVpOG4q+ffu6Tkdak88L5XvhGznhZ09tVl765/Dahdq1WyslSJdAqYfAGoA8HjP61P1sb3+Dzi5ppL/C8XCKc0XnzQ2pEPKD5yaazCruOYC6+Sb/7aRvY6BYh4VR2recc/XqaYTnGTN9IPEwfzIvFIQc8VDBW4Jy4G0V2BV4
 gHNauW/J
 bwsrYJDhS9lWe371Wdv9lyFa9CZ/5P+nkxIClz6DpbGW3WTVhkUCJtxXdaGlebRhLh8wI4vfCnJJqN8Vh4u5/1Dh7+FQ9I5b5fWjIT8z8rgLWoXa+leUap9AKypJQyYAQTGYshunygQUoUOj6VbjaziSDYMwvuIjaujdmz8R/SasxicWcQBponcu4d0cBsbhPMye0PEE87qleVYQMwo+fQybQe3g/CQwDUMO50zbPRlXewgEmHysaxC80IF7uDNggz6EMCRS+cm7Yw14hHXvF01RKYTlNSxvtKU4YXrByV7SkO7WbXtPwarh21yCMwv/f4PCR9p2WBvYoNQ8sDUdHEtYLuUaR1mRMVadja15slC+A0MXjqF0exX4eeJaN0EFOkm9/wBr3H/98zxnPcyWJWxYMvc4Q3sJKjYYdTs4bNvIGIZZ9wQQCxTC2mYjS1rL2z6mM575kDPwBGWm4p7c6WuJvqzbw9BnG2rAJJQXUxpWW3VtfR5apx5VK5kB7ls6s/L187iloHyK8ApD3O4ZQQxAoMwpzrruLwr/0FOEKnmE3cBsV0w3QvGH5gqcHmTbeBm+ivX/gJ7Rp0aXGMUSM5eaOgz/tRQklWPSuxVUygCtn71+PSM6aADNx2xC7wJkNPojIo7tZJgi9KWWkok8TkAwOFOL8oYbRvBfGda3y/yyQ1tSGHa6duYMw/PCh7G7BalvxnInkujn7n6gWcNowJIAUIti7z97ipjsx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 5:59=E2=80=AFAM Xueyuan Chen <xueyuan.chen21@gmail.c=
om> wrote:
>
> Zsmalloc statistics are now available when debugfs is enabled. Replace
> references to CONFIG_ZSMALLOC_STAT with CONFIG_DEBUG_FS in the English
> and Chinese documentation.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

For the English documentation:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

(but I'm mildly certain the Chinese one is also correct :))

