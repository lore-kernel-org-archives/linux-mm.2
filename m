Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F0A606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=ZbU0ibdW
Received: by kanga.kvack.org (Postfix)
	id 2403A6B05B2; Thu,  5 Nov 2026 16:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F11F6B05B4; Thu,  5 Nov 2026 16:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0BD6B05B9; Thu,  5 Nov 2026 16:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9B556B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:03:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CF2EA8AFD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:03:03 +0000 (UTC)
X-FDA: 85402290246.29.0659005
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 27270C0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:03:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ZbU0ibdW;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793912581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIPsFgpeDDDerv0ETdjJMk/BOk+taB7WxA1rqOHL3fI=;
	b=CO3/B52SaqlCitZ+RRKqEdVKJY98AmFzqN0sECeQIaH95eyjurOMscemaNZYfuhda97V2n
	NsUje5TWtl9FHUYSUNssXh5+UOGseOgIorVQzT049OBmZzJb8s1txqG2tscDtxaCrTvdmr
	OrRHZbcjWYfNwDYcRpnaazx9Jvd4mvQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793912581;
	b=rlrLyZuWIrft/dGnLeW88b/p/DPpreVfMFElTZfE9+LJgfHVbyISF8v0F8Lkv9itXgV+wM
	LujjV41RjKfdFft6qo/mJd5lU3RICl6hpyq+2aE7JPivvt9zMGx6397++sZV+xg673/3hg
	rngkmPwdQIgxaKk6OpeZo+J5AwABwQk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ZbU0ibdW;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso3535248a12.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793912579; x=1794517379; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vIPsFgpeDDDerv0ETdjJMk/BOk+taB7WxA1rqOHL3fI=;
        b=ZbU0ibdWuDV29xa0cuDrUfXtRfptA+t9iy7vRgYT0igPoIVL4EyShKs4Vu/3CQdz16
         MiGeJv5NCOKWiDkoz1nieeZAqk247ZT9G/UozDBi/gYylg2WKN+4rytSJjKowb19EKdi
         PBck8KzF7HoWIsuSscPh8KDVfa+q35bN0gYsE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793912579; x=1794517379;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vIPsFgpeDDDerv0ETdjJMk/BOk+taB7WxA1rqOHL3fI=;
        b=0KopbZgHWJKoZYZixYTAYaDC2yLXMgc0bezfbX6+KKZweQkJHMbFLNE6NMBVGIJ++w
         0k82WOcm6t1NVBthZpXeMLlv8UeJiTkU9v52hUBg+noiPUMtQGCD8vtQY9Tf5l9v3R+Y
         Y80G8aZ2yYDp6m/xY/2G2u4nHgSgqg189lwFQT/CfoZYWlBYvt2j3DthVVr/8dc+5UDZ
         +G+uKFcCpCH1mMvZLyA//DxH9QeiLFUJn+vUZnuIkW0ltR/gI4Yt3b/bVQ3BpAlLl11l
         h1UHd17Q1h1dTF24/4vSUZefbySo1Wfg6903vFb+RHpNjm0/CFh2oMm7kMvFkoomqNw8
         oUWQ==
X-Forwarded-Encrypted: i=1; AKwUvByqgYO4BJWjRciUjlql0OpNKqkIMYfvhYWp8b6X/l/zdPCuF5yeBmCdHnj2pTxe0sHl7Wu2DxrQ9A==@kvack.org
X-Gm-Message-State: APuU4Z9UctKEHREq2SRLfKvTOAMqsjaWXs4RuxbOUsUlG5vMxBq7DX48
	P5tBFr4mwvsIEbZ4V4j5FN2uI/yG3i/Z0w+FAyPZD6cUMOgEAbLJUrXCBS2MzWtobp2aWgr1J/d
	sqldC000=
X-Gm-Gg: AYBFou2XvXoE03U4WfvG4Nw45oXtQ821LD+Q3cJKxi6Mwrn209NCVg1ZaADxSaTq817
	XqAJaDKRNOacYHqX1YW2+0pODVU7Up6YhqIImsUrZo6zoaJPZ6k5mdq4VKGgoEWhksYDcs7vHl8
	0YbDI6HzeO2z47Tesn/YyfPvOqVYfRjFDgZB9+lw3o3/K2MkDKZfeDnuglDL3S9uUqBhnZqS/0R
	wrAdqSAy6E1ZH66rvuPpwCw02ctFcxt9l/0tBttC2w5g6KnbV40xOuBNFjrxGySr7WlX32kkvO8
	KI6cU0bnfpACIkQ8UULSS60AkEbhYY2Pr4v6euGTIski4OJapnYCBhMFIUu4baDIPE5jF6htiKb
	qHebKeErBa/vbxbIrKcy1yjPsyj09Uef1g6F/YM+oa7Owu1YyHHg8jdY6rKL2YEXhRo2twJbLtB
	AnVTzyMXa/l+MA0C+Bnexg9mvv5H+qMIZaRvMKbwIrU4febhq4XHxon8o7rXMY/52x+PxjPl7qI
	l032dfwWKvPL8/C1EowxIHMiSA4yJ8jcqY33WyecF9bo+IZLY6TAtWqvj6i7sMAS3n99Nn4dr2w
	+UaCJZsTACqj8yQbZjVyCpGAEuFq05/VOZ3XWFLRNMB2Vqm8kmmEmxE1Xwj4CrszHeX9DnhfLI1
	RZ3xMPm96K37vcHYc9SDi41I+
X-Received: by 2002:a05:6402:2485:b0:6ac:62aa:e3dc with SMTP id 4fb4d7f45d1cf-6b5978061bemr276132a12.26.1793912579346;
        Thu, 05 Nov 2026 13:02:59 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b574e00988sm1261070a12.10.2026.11.05.13.02.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:02:55 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4301e334ceso203162166b.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:02:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx93jCHID1M9vmFlaZL30h+qnNXwFKxhxHUS10OocxxNeqvvNeEHVPS5TsaQlj/cbrbzJ4mtZLnrw==@kvack.org
X-Received: by 2002:a17:906:c150:b0:c46:9ca9:f524 with SMTP id
 a640c23a62f3a-c4d354b9d04mr48470966b.32.1793912574580; Thu, 05 Nov 2026
 13:02:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au> <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au> <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au> <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au> <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au> <auzOjphJ8DWpXwUy@milan>
In-Reply-To: <auzOjphJ8DWpXwUy@milan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Nov 2026 13:02:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
X-Gm-Features: AclHuK-6zo-9KtIYF9n0Bopl194z1pM7LoK-Wva3VmRK1J9HSt04b5Zu07i1Nu8
Message-ID: <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"Liam R. Howlett (Google)" <liam@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>, 
	Baoquan He <bhe@redhat.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Marco Elver <elver@google.com>, 
	Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27270C0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: zick5ioce4pfcbbdyby5c49axeewtuyw
X-Rspam-User: 
X-HE-Tag: 1793912580-165767
X-HE-Meta: U2FsdGVkX1/c5ncjPXZtn1kqUL7a1t0ElMIAYAh/K9da5nN3RYzfkrM7TXDUGVSiEh2Gq72hOGW+U8LpNoL7+F66s7djS8sOPQqJx2mbVzH2duMtwnm8LEJIggfUPvSfMH9e8oq0KK/0oRqnbk6V4vTXAmN/iCA72ZnYuCg8S/WiZ94gskRt3UgWfH41vZuuLcOmPWLnaoXrpa1ly46wIQVPqmQrs2eBEDMN4Yo1CTUm7Sq8KxXrRp9Mg4CLp73zQG0Yw1aIYzmJwp2W9TPjsSIhcxk48aw3qx2XnlxtGhN9m6g6QF9/cCWCdMU0HDJWEGIza44PR8f+3wgFqUQ6/9jCEkItUjWkxoKjwIZOcEDDF5jpGiExFTV5jUCSt8aeZGipYQS19i0e8fSJw108Jj7cIBB/tl7NoNrOWea5xoF7NGMbVvZoi5KuBHEBfc8b5N5Io61eevhKAy9yzEUkHeXwSwnuBKjM+OkSbJpqgaFPkznJwWYLDm9gV7b07GWAEqx3cXlQQi0p9jQYiwJ6CgKh9J6hh/PkdSHUyjMQOsRiIrSdiMYztF1JpT15AMbyAcy48Z0/6aqTZWANHBfZp/wwSfYSBUUaKX9ImZgaB6LUxr07Q+BxGFVcESPXZOtfwGH7yjyEEJncaoYq8wqYEjQscCxKg0e1Rljd1roQT57lUygc9m8xQd8k+UC3AWvK0wkgjjMXSeAJFCqU0YoSXiCqlR8FBNasfweDejnmCk4x5h9WyOhJePueLxdH84fmYz88SnXxCZP6WKIe2Sel03ZaVI+Y4R/kC8mSv/2I2vA8BNWVcuFcNzbSRbYCjEDb2+MCHVXDwUHMvGnPTbEeqZYdVoB6qRI/IIQV2wdYM8lZUwGCF7EQ9ZIwAbdGOBiyORDdVWhSE6ma/4r21d1LgnWj+e+pi/3vyhX/XEuMe3j329QHthG1CTzWvZqunC6S8PJ7yaFTqYEHBGyDgct
 +yzQzYkA
 tUhLJafvfHPvN3K+U4W2uyaAyBbkSgtSNf3QtERb50L1n66GZXgXkNkxmX0QLjG0VBeR2PrGC1JSaS4ZdtA++Q+9lgTuEwWBJ9ZjX6zPAZ37RH89LXgiSDAdPImCpQWHyRUtC+xQeXzluPNlS9bELS2tvds++onZXcFJBYNIrS5jtN3NpGV7y4GFRhF7P+pbkCbBgbUUMQOLZaCrRCCT1BZHSPsIXDJvNJ7tVWl5+eSIqLNu1hLhxvTVUQdOE6VLaoeKGNl5JnQL8SGWnTwmdPdQhYd4OusSlL3emxgJ8my+lFHxgz3SGtN7+CJfhgWo1rA2ijtXqYXHdTQre5GsXu+ykneDtgwGqoRGggi6XOthNNq3I0Njk3+WeozcQKeB7IbRO9enRr+HiwaF5sqCNd8HNwZn5LBaRGtSOFfR+fceJQW2VQM5AvE1LzRQUH9CopRXlPDy/KuQne/t8VA10WM5YYxD0NaGs1mVtgUbWO9UGiror5gYtNRR+jzAxmvMKPHEyGu26BTY6on3ophX23Df4BE3TaBkQgfYH7tqV/qngqiMP74AqVuhXo16Mc05OpOIT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026 at 10:44, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> @@ -1025,7 +1025,13 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>                         }
>                 }
>         } else {
> -               spin_lock(&br->hash_lock);
> +               if (in_serving_softirq()) {
> +                       if (!spin_trylock(&br->hash_lock))

I don't think that in_serving_softirq() makes any sense.

If I read this code correctly - and it's possible I didn't - this is
always called under local_bh_disable().

And local_bh_disable() will have increased the preempt-count exactly
so that it looks like it's in_serving_softirq().

Maybe I got lost somewhere, but it basically looks like that test will
always be true and is pointless (and misleading).

         Linus

