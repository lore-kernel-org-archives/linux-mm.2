Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A82D606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=DOH8cq/U
Received: by kanga.kvack.org (Postfix)
	id 32C616B05B3; Fri, 13 Nov 2026 21:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D64C6B05B4; Fri, 13 Nov 2026 21:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6D16B05B5; Fri, 13 Nov 2026 21:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7DC06B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:19:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFA80A7D2A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:19:27 +0000 (UTC)
X-FDA: 85432117974.12.24C4407
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id AB8F820002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:19:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="DOH8cq/U";
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794622766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFEobrAf6WirewKCvSBOHq5k7Hbpzktec7ALKOJWs3s=;
	b=vy4btT5c5miVYCSH6ExMWH7QXFqtd0Jwwiuo1rlQ8clvJGZYCrAGFL92p9pR7u2G9psD/N
	/UyEQuRWTM+/mlfYu2CNvbfJ2in0iuLTFyfZwMail5YEzF31LOLyI4tKgPLKleKLrru3mB
	7EwAToQUg8XpTppwxpSnBitz8wO/9Iw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794622766;
	b=jH16Ms9jafqLiX+tOKw3YXW3Qu+IJTflV0PF+1G7iACzHhgthq3a4bPihp+Eh5hgSh2viO
	LzT90cgL9Qt63Dw/zwiOmRxVMhaAgrKiylrX0ziqItu2o8B5y/mxelK3+epQkbynDeuvWj
	lCLIIRQ5xrkVloBo7janb0Cn+UlBgxg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="DOH8cq/U";
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c50a4a2132cso212739866b.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794622764; x=1795227564; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xFEobrAf6WirewKCvSBOHq5k7Hbpzktec7ALKOJWs3s=;
        b=DOH8cq/UdG6lYohBo/30VYPSFcoYYnqFyHMmkw6O9TNTni2Bq7eVj+Sj6rg7+MgRyG
         +NpFDfiC1foCNFHJdjua0hUP45qvhKAcwXkaBLzrAzt+46LvDUWqGERowo3OYeNmRA0I
         vgqZMQb+pRTQh/4szmMhx1gxXbO4ydeljtcDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794622764; x=1795227564;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xFEobrAf6WirewKCvSBOHq5k7Hbpzktec7ALKOJWs3s=;
        b=Do2RfFARY4TWXyAc6hXaaAYYOtXdNoXTBE1clA9DvhZpDcn3KCn3zZyePrr4XxFd0W
         cmJzjxe0IvhzfR2mXIEEbnMR7AE/ErNyMfjiknluhX/d6YdqJlxQ8dh+OQr1F9T8kfkU
         ulQaix97kZiCx2qJtgxwP7n3O+ANshexe8iNXQ/VvfkHmRUYEft+4rn4o3JYd7B4iwVB
         W0/uLECCF9ByHLdyQYYp08U31cOUPptq55BpkcUtjT10EYt6jr9ngwlm8ToiWd6EYMB7
         iPScrDlnUOoWdT/yNPApgdM6pHgztHhVt6iN1+ddcXJsDnG50V9OUTFqbDkLUbKpAyJJ
         bCeA==
X-Forwarded-Encrypted: i=1; AL+hErEPAfNyjFCJlBd3lLIQS2tW2qqQOkqsWMvnMCrj0ovIGCo2pSdpp60NRtzuTtGzm+Unshk9f+OVOQ==@kvack.org
X-Gm-Message-State: APuU4Z/QDj293hOzkQKrbmFSUxSfpkrTRpJSVutP62ElDXcxt6CfWpec
	QQagz1v4lLv/IFe7iC6V9v3AVVBLOStqUdiakMIfwsIGWvRSPE1ahcMTt0XZMWyAHBVkjdtBcdo
	5G9d/ljuedA==
X-Gm-Gg: AYBFou2QRJsgppcR9lKYqzUBXtLqWEWzIGc8p2BrMZ0aa5HnlxHpaTHqF03ZAq0W4SS
	d46+kO31A4Ahh+F3no7YAnkvP7fL7H4Cc0E82s7VKkNLOG7EGI/Qk17zhf1Cu2aSL1brvKO1Pn3
	29bo/GnA5Rg0ZOpCenUPTZmGyMAZiTGH96rxgNSf0n9FMopr3nDF2PzaAcmzJOxtbhfLtb7cFg9
	RvqnyuJPqWN4mM9q8xQEYVxzgmozGBAK1OwGrLhxIckk+Bzo6qADzVzrRzUhTFBiRea5L12wRdi
	C8meByrj0ihDgBlaNZKrgroOF19GAN7Fqp0FgXOjY7d+0tf3GSaQXOjXNI1UlZOa3r/AFqfLzvi
	BSipirE07GrLLlXUdWCqK3Q0XSTdGsOzeslVed3O5eFA4lWY9iTkSjE2NUb+U7nKUsK2GsOhDDe
	jrL7udCPzTOv2ZT52WTejO3KiF7dh3TBLWMngcxiGsFo4wcU35BVWyrgSRK1rzj+E9AK+HYkyoC
	euEHNmPZVAZZE1IMkHyqMR9O6CaWPZoQhsBL2wg5FLpI/anFdDqOSK/tcrqv3HlogsAXlQUbCII
	P+rrvl2kGAjA6KcXiIRbpAh3f2Y+QoNfnPM4GaAWUIcWDYlZPSZW1iXCkqX9sfRDBlVjYVwqxo+
	W9pE=
X-Received: by 2002:a17:907:a714:b0:c42:5363:38dc with SMTP id a640c23a62f3a-c509637e20cmr348567066b.25.1794622763975;
        Fri, 13 Nov 2026 18:19:23 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c25deb10sm1698520a12.30.2026.11.13.18.19.23
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 18:19:23 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b7bffb5b8fso2466220a12.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:19:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHZGO0SqLEEdr41hRI4FfE0/cgY7xmuaSrFUk2NeIHqDfEdVB4sKP5RELAfKmvS4plBZn9VAl5o6A==@kvack.org
X-Received: by 2002:a05:6402:2b87:b0:6b5:8695:f839 with SMTP id
 4fb4d7f45d1cf-6b7c0d24fdfmr3606529a12.45.1794622762852; Fri, 13 Nov 2026
 18:19:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au> <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au> <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au> <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
 <auy-7TvVzJ-VCrG4@milan> <avcKfEvln8_2a7fJ@gondor.apana.org.au>
 <CAHk-=wg9baZ9EDhZr7ONxjuO65+vvWFo5E2hgxt+3rYo1vnhyA@mail.gmail.com> <aves3p5vrqqAuHma@gondor.apana.org.au>
In-Reply-To: <aves3p5vrqqAuHma@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Nov 2026 18:19:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjhtBnAz6YniHqcVJDCDvVVNp_UUL3QbiYyS6u+yKcNgQ@mail.gmail.com>
X-Gm-Features: AclHuK9T8qB_5bmjhcK4UnFzb5yfP0GrEfjJOo4l7azLABG4Kermbip3IVeKi4Q
Message-ID: <CAHk-=wjhtBnAz6YniHqcVJDCDvVVNp_UUL3QbiYyS6u+yKcNgQ@mail.gmail.com>
Subject: Re: [PATCH] mm: kvmalloc: Bail if called with soft or hard IRQs disabled
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett (Google)" <liam@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB8F820002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: h4r4pf7njp3aboqnbr1b5jz33iqb46iu
X-Rspam-User: 
X-HE-Tag: 1794622765-70710
X-HE-Meta: U2FsdGVkX19LL78rCgBnLlPwpDJ+8ITFQUSIXiTYpyflfo+5L3R3Mx573LJOECBO/bGQkRxbagkt4qhYoEHcPxYBOJgXiwTbhVLPTnY79xoXOz03sPsuaqrWhaK5ssevx43/B1rFsXwhEMqiAoeYF3RJB/Y8Ci1j+hWKSQpcvPjJJY0BUd8xXih4+BIxci5rSVSrSx3rrbZVHU3tCMVPHNRdHovzEAwfMMyQ38asRu9YrmUQst7Mx6W0vjlFNFOhZV9RFzgVTMscHwqdVJRGJw7/ySbQgpFVI4vJXnJfPRYo+XUwu8Hi+XcNAB4KTQ1W3VIYihGdy0XGDrYJ9aAd1FHapSJm0+b2XvWvuH3hPPO+gqcEl1sDJX4Lf5/CkseNNKkjZJnHJ71hQFtRuJE0hqsqowQ5m8cQlL1K0ccX8/qrOo6UXk627VIUvLN63FOBv/E8w/u9EWiJBmVHzlnveA1bibyD8UPVxmrEAO6B1VBSMhc+qT9XDVEiuhMlqRxztOspCnZjx35+KA1Y/9RcqGyW5D08ZOR0AySVajTK/3wRjLeFuo/rxfXdmrfQigjBssTq9bq3h/eoMY5J29bodSbZ8FGcLmC7DgeGUKVgb0+GCKTNuZXDLhVfFD/T/nf94z/kKuKlA3qrIiLXJdF9MbEmecdoNuquBW9ejm4XQl0NLkfNeguG5AzKC2ga62oQZOOBgKSvQR+SZzARE6fF+K/0gZXXiOBlvP78I/uh1hmxPDqGUB9Zyo3o73Aw7BNQ/EVR/tabVZtlDtixuqPXDcpki75O5wI2J1oGJ2HzazgLqEjucSa4uIsW5BUAolrD8IfsWa8oHqwAFM+PRBokgPQRQEz1POWPXUOL85R6KO/likx1YybzY4/5bYU1riCoDlmLj8wgPtmIs6E6E2tEMftVBj/T4196a+peHftUkWZ3ajzZxewz4FgLhkPsrW3ZLNQ1RApoYR9O8DD1RTi
 Ps/sa0U3
 3/Pn0usBtiUxj32uRd4a3Jx987oGsSfay9B0IJU2hKAjY4c8zImkOQyK0H5BEZNs2ZPqdmAzQyKtzmdKUFp4qxMLWbpAdb76eJlcn1VoCgYy9LTu0wr3smgAf9EGKitAWlXIEnFsm9EDRIxKRplVrP2oa6s4UdmgXCHu5z+1x1C2urogSKa8aQCq5Le1fbb7yoDCaAOQz4p0PKB71Qsnme3mTxnkhtVutzFXVn+rOOpO+lQMLW3jAv6rCHOmstdM1EAUO7XlFoJqA2o2xvdELiRZ2QCO052hv8xTD1m7AVHMxH8KAzP5dJrwHVXcttoeeOpUesDObPvgRT77s3myBTTzZJypb+tP9PtRtpl3TMn5gtEmTmPBFAyrX3j+TwjCu88ZelUDJKt5zTifCj4onH9M1j/WiOQU8PMRYxfICwbHJIeQt9fKE/l8xwGpdKd57QqR2OguP39Tp/pfdRgLxAK1k/3bNyuYigFQ8s9eHoqOHzL2Gp8sy2cprni5NUyWWZryNsUNrdBOL22hUaXKQTnUEGuFInL55wcf+q/ezfsNTVAas6aDqmDMpCXc/IGZu0plcXjOBA2J7CGZAvdy6Z+Pq//KekBTR9k7FCgK920s9HxCFvPrsjLdugoUuXJ3V8Reu/7UObcZfd/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 at 16:35, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> That would make sense for direct vmalloc calls.  But this is
> kvmalloc, which is supposed to choose automatically between
> kmalloc and vmalloc.

Yes. But that cl;early caused problems, and then people seemed to
start thinking that it meant that the vmalloc side should also work
with GFP_ATOMIC.

If you are in atomic context, then kvmalloc() makes no sense, since
the vmalloc makes no sense. You should use kmalloc.

          Linus

