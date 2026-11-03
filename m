Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5E5606B10E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l+HuCZJQ
Received: by kanga.kvack.org (Postfix)
	id 8F2826B00EF; Tue,  3 Nov 2026 06:08:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3E46B05B1; Tue,  3 Nov 2026 06:08:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792496B05B2; Tue,  3 Nov 2026 06:08:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53D8E6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:08:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DABA314036A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:08:44 +0000 (UTC)
X-FDA: 85393534968.15.C356E45
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id E9A391C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:08:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l+HuCZJQ;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793704122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AloFYWUzIqAhdMvN8K6X8VlvrRNVo6qD2kbJJy05K7U=;
	b=NplIc9MToOnosLhlhnNpT4+D7fmH56IKAMUk+OsMbJi0CS5tNy5hAYR7+HL615HAhWUegr
	XM4feaQo3kiy47zz96ihNkUbrKs9oIxfdc3hts4X9+NiG+wPHNkpoUhirJUXw5SxlTF5Jz
	A4MpY/oFbmw92ciKWWfTH22Ph6RX3KQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l+HuCZJQ;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793704122;
	b=AtAnIioTsW9woNtlVMYB3U5YhTgCyUE/W8p7KrYXdb2giHAKfcIyykWD1d2BhRgCM6Qocx
	VcYiuQsQxSuJT3Oos8Wcc0U2eNWgcePYU+oybNrp+H7yjIx6qBnSP/V/76LYhHJ6EKRdjj
	+tAoFq5ekyQ4P1nCswSUeewWcEjRkk4=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e0d1da913so450781f8f.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793704121; x=1794308921; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AloFYWUzIqAhdMvN8K6X8VlvrRNVo6qD2kbJJy05K7U=;
        b=l+HuCZJQT+KH8gDijxRwPFS+zux9yvDluWzIu8sp/P1ywr1oP5PTyqQ7y3dmqNFgvK
         YnKm2w/+3KvtnC2nv796V26vlneLVBG0DQtcEv4I5jLRmlz5u4iT4qZenz/be5ZDFm1r
         Bh2wO7xjt7NRwGqmTuADnG40l1qHON4iBmWRwvP4/R7o+L9WnUP6Z+KLmpsa9OE4N5FH
         IHO/JFbPpjPV+Ldc+pMorkyyiVa+M1vUhjH3ZIm1MAAdyJ/D4eWTyEd563nW13ubWnS+
         0kdwh3RBMnHEB0wuvBygZ6fSbRh28jS2JeTA+eg7NFO080W7q/tAPOihP9DfQ/sZfyzZ
         HGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793704121; x=1794308921;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AloFYWUzIqAhdMvN8K6X8VlvrRNVo6qD2kbJJy05K7U=;
        b=q+KFpW3LBQC2krVf08Eh1m6nSDyMMlLw/DqJYLsNth74hs+kCwh42VzoK6Wcf4z4Er
         YN9l+8hGpH0AEHTPrjnSHYj7HvsxiROkl0D9oYjjK3P68px+KDxs/YQs/opR0E9JMOBe
         dF4naOFzYM+XhW4z490/FCgLYPp/tVPEshnyimX8jN2iNdTvHhEURejEg65Qzpzr9ySn
         YVjwTpi3kuVPToWD9knU42Niv/OoH8i9MNAK7uOxXhmRJlOZVA9skXNy9bn6IyiuqTTQ
         OYaZNtgA2a8Ljd31R4fP9c2oLNc47cRqeEIwa6zpb5DeEdI/eV1R7NqOLYhwinrfeRmx
         8ThA==
X-Forwarded-Encrypted: i=1; AKwUvBxbKNNbOB0ePAIspIWFsOgUgLFDMa5Gdd+B0IxhcvGJfYu7glAshnDvNgvfqjv3o/Yf5+FJyjBYXA==@kvack.org
X-Gm-Message-State: APuU4Z/CJsdqOPQO43Y4mIsE1vRgiNWtbg/Ock1UJeqwGjy8Q6TIUGCQ
	2GHq+h3RVYpLLsleRTYbqjm4yN0hjKhgIYBnQe+UZ8ow2BzqlyKUWVNn
X-Gm-Gg: AYBFou27X7MwyizlvRqR+jVVmdo9WbTtTf/qxX77wRO+nRpmSDDsTC6yAVnlQW2nv5T
	kAG5GsvbrTLw3N2VnEnArd19CVfGQvRjFax5gq8OnN2k7uFAWGkLFKfyIYYm2fhc9UF7vxluTnm
	fJOFGC/bAbQboDe/InlfInNtKttq55JkMdJQuBBPZ7uyFde4mXNeNYTfxgSnNtDZtGqbmN5h2Dw
	gaug7M2O4TjtaORW6WSQCg9uqNpZ5Qb8mjwYX4W7R1xiy6kENx+Wg+Lyah1SV3zh0S0KSpekc+c
	xbZohUO/KMy+AyxUegS7FdxaY2LqKQKBNQ7rArDtPh8f5oDXEg3U67+ZBdBA2sCweXjQP2JQKhM
	A7YtFS6mSrc1fqFu3JVMSAj95yRo9rBOgQbyBRwIq5q0d89l0o1vda6gZXEbM6mxHrQfagkloAZ
	bjmSQ/hzY6VJEssOa5Uc29gfoVrWq8pm5dWr6IcHkuu+4C4ETVpv+QLe53pHqppp2CVO7jQwn3S
	Jf+tmXRif10hI+UbKpk1qUWXgOD2WlvbJNAarootbMuUaxVHHMjZimc9olLFuiABrLy3Nv8I3rD
	ITs1D1Lx+ATcLI3Ro/XyJeQunAuhlGtEKWqR3DBVO7rc
X-Received: by 2002:a5d:584e:0:b0:48e:6669:fefb with SMTP id ffacd0b85a97d-48e6e2e2369mr30210705f8f.22.1793704121330;
        Tue, 03 Nov 2026 03:08:41 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm27509475f8f.31.2026.11.03.03.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 03:08:38 -0800 (PST)
Message-ID: <9ffda863-507e-4911-8d4e-dbb7f0e26544@gmail.com>
Date: Tue, 3 Nov 2026 12:08:36 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm/mremap: restore VMA_ACCOUNT_BIT if the unmap
 fails
To: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
 <20261102-b4-mremap-pre-split-v2-4-d281dd11ad7d@toxicpanda.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-4-d281dd11ad7d@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uceunkp14my6fdy6ps51ka5o1fubhren
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E9A391C0002
X-HE-Tag: 1793704122-70366
X-HE-Meta: U2FsdGVkX18eqE10lrAnCQu+S6OwyyoDTl5/xN8g63u/FRhH7RuL/r9YYijJ96kqfije8MHcZmH6/C7axPk+DzrFTvY4XqAM58qbjB2cA3NQdxYJAtOkebpsR3KavXRR62br46OI+eJvuO6i/tsFyWZoJMyWEg7F6QgBeaRmUXoOlkm+LkYZVHtTlrpUS8Z0bM+9hr/QAdvqy4o72deK55Tc17SrBLgi36JPTCQwUkdeFw+uPqysEYPwnKYbHz/Y7BxXdy2Ph5vA1mjNixYCDIsb1t5CySgnRTvD8uZWo5h72N96rCtDGYZRmASaex/l/jW7gBtPvWKD4wNwoEmpP48ZbJZlbi1PMtK9szfcOV38yjYQW9Zz8Vv8KLxrU/KwQEI9NADSYoKCOCgWWB/j361WlFoViB1TCaVm0csQHr5CYEtR+G8xkNMA5hFmfqd1s7n8AJgL8LLN49XtIDsqJlbZfvYi2Q5XO8L/tXkQfkwbwKcOxCbvrk50EueT2UL+KIEchS+zdrLfBve1/mwCw2BNJseIwcX9yZs8uIBYwanQYMfKSblGeTnpDoQlwDdP9FSKprbpIyXVXgAnDSbiJ/F1lRCv/el80DhUtLjNnBpG0ZeuQP6LLWyeezlYPR9TZ0Stv1owbikYre2NIofQROTU7IG8Gy6Hi8XKvJFyLAR6lcPoUCqOq3IkM1m0JhylUJrVN79CcoKhfPX67rvLWjsjKILbGaW1RCKZDfXScqywoTYEUGP3wtp4vxq4LeCTxFznx6zU8tcWVm3tUpgA5EGSyJOrCWl/VzmcvrLJqNhHLAPR20MGIB8EWUtqMjZ2LJz1bkhSNgXNP/HTWrYUAmVMozqJ41n/FWVa8xzL00Mp8s3rBKuXzI056O95jc0nMLoO7UJv+s+cMZQZFxi+tXVxZQWNYaugsxyp6zNhExv6PXM8+ea7HGS0YD++UWBB8nzzsS7sZeuC9QmpDHy
 ZLCc0hSZ
 8NgAy6/CBE4TgkjFuMHsa6BzCVYf7pxtHGaCNi7kEvJHuibWwNx6JVsJP5cD65LELSYDO3wOztkLyBDPubRIuACDk3MgvO5rWL8yXzM8IliT3YnA7nBFGCeRQW0rIUmScfBJ6MpM/wbvfo+vpkqMq/gFRL4oS9j8sL3oZL3PIxz03LdvXO3z/4jiAIWHR/fBfpbijVzHSV51lgEZvy6sHXB3XxDGiar2jGPY9zGrNetObJGtcpv1Lh2MOImh/I/Ghz6/v/Y+Ph1xrUvKKimB8vQiDauvGh6uy1zmTrXH4elkCB1rQpwjzWuvn353Q/JGisEsGVQok7e+wBImCIMhdHqXGLi+s8m8JYGSidqT81B4CCpL5wsVX/bB3nDaOJTE/QKVGXSNxlQb5pIHVqFXjUDzbQ4ZWR31TcS5h5lGHM+DEDnzj4ExUMaH/HQ+YPNdkn+h0aATez0q1MZmH24hCsI9RFR/JCF7ZmyomyET6sJSeKBmVLjkBMNkHSVN2N4/E2pH8x/rEuOPUnjBoirK+gWYD8IeW74VVaRmTZclpil1U1NW1kS05v2cFGiQSRWfKU3wv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 12:46 AM, Josef Bacik wrote:
> If the unmap at the end of an mremap() move fails, the source VMA stays
> without VMA_ACCOUNT_BIT. Neither munmap() nor exit_mmap() uncharges it
> then, so the charge for all of its pages stays in vm_committed_as after
> the process is gone.
> 
> unmap_source_vma() clears the flag on the whole source VMA before the unmap
> and sets it again on the remaining parts afterwards, but its error path
> returns without doing so.
> 
> This was reproduced with fault injection: each failure on an anonymous
> mapping left Committed_AS higher by the size of the whole VMA after
> everything was unmapped.
> 
> Fix by setting the flag again on everything in the range of the original
> VMA, on both paths, with a new helper. A failed unmap may have split the
> VMA already, so the helper walks the range.
> 
> Fixes: 51df7bcb6151 ("mm/mremap: account memory on do_munmap() failure")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

nice!

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

