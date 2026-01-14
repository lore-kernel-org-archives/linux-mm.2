Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445D9D38FEE
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975E76B0005; Wed, 14 Jan 2026 11:54:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D5E6B0096; Wed, 14 Jan 2026 11:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AF86B009B; Wed, 14 Jan 2026 11:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 790E66B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:54:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 302931BDEF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:54:22 +0000 (UTC)
X-FDA: 84331167564.20.F4331EF
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5001F180003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:54:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WGphFBju;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqwRJpxue33MOl5GGObv53v1MmSJ6VidNvLuqKaRC+o=;
	b=Xz7NF9LXktcdeuojbLWhQONyDjgPOXWyUHSPpf1Jm1VjTP1zi55tWAIB/5UPJ/0jZ6KSFl
	aly/bP6rAd7NIdZdvHFpMdOcNshYp7iF2h2oa84rp1/NtxhXEn7lonD24powRed5rzdDR3
	6z6NZpZUjW7n5Q+R2FUVm4GqDGAILrQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WGphFBju;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409660; a=rsa-sha256;
	cv=none;
	b=kodf+6JkwRFQPosvq6tV4UeZfqC1UEFCd0J7N4MojKXCVEFnsZWnqWG/izZ2JIRWHdOIoZ
	AeO5TwfXha1CcIK+aztlZPc+3K2HqLXSkWsmkgKfNcLBZRjTbK0ISaaozwndfry4RoC+K8
	JVZcDjN7SbrWoLdxJcw1rEFg/QTeg4k=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b87693c981fso10888166b.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768409658; x=1769014458; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KqwRJpxue33MOl5GGObv53v1MmSJ6VidNvLuqKaRC+o=;
        b=WGphFBjuHIJSq3Uo+fl3ql97GKhLHWYBrN8KplLb8CxxkzLlxqRGnQ2BYWhN12xyS3
         jNQoSbl/kRGHZ/1EGTbd+RwOjxkYhcE9DzByohcU1yT0n2rlIoNDoB0KHGUrM1s2RSkv
         +iwCqWMdJNq3MiaIFaJg6snwSUBQLDXSbPy4kXpWsY6MCpME89wyqG6n4HHDxynfrVAw
         6Xg52oZQnZGBuB9uKMkJUFc+JsWD7gptC26cdWEDblMhDtnIDAJfalGyLEhfNcssnKcc
         xA7YQiYzAkPl7t0o+99R2BHIjItHjPso2AiawO3N3eyWRx9FLa/HuqUXIWfi1rBFEKtw
         Z2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409658; x=1769014458;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqwRJpxue33MOl5GGObv53v1MmSJ6VidNvLuqKaRC+o=;
        b=sz0Bo+EnjtNQ9uvdgcSAY6HPVKyVDyq/Ee4rCL9o0a80IgfrQDeitZSVGfVj8sTWHo
         iQt0RtrPztPRFSHZH1wCEN57EtmyLzdZJR2i5GUYFSKttzrQTaNaY655L0/S7+wA2hPa
         G4lcDifsyUOi06dOANvWXcRQIqco7rxeyYTpoOq1UcNxEcNIeQMr8hRYfUJTf41Clm0R
         VsDyNvXpLXaQrWkA12shIT1EJx7ZjzUMFaktwoLHSiSEjAUyxErWQYu0aQvaUATr2Qj0
         Gl5ZNCkFBvwEirg/1SfmHlpI68DDZMNdVd0xp1Mkv+QMmhCdD7P4lzcbq/J6j36jPV91
         uryA==
X-Forwarded-Encrypted: i=1; AJvYcCVT1na3ZX4D/26XU3mGm2BU579UnKh5xg+Nwak2bl/nGKQi6VMrRVC5SwUIOavmlwyE5dBEdGHvBg==@kvack.org
X-Gm-Message-State: AOJu0YwcExg0cEoyl2s/y9SiF7qSFk/0hoY5BoYgb0qoxOM/MuzdNrtP
	3V+/FatCav3/f5vy2SLkJif0/yQrT+czHrYQIhvxAp6BQW6VvmjjPSrTYYdngvUxgzRRj+fpxKf
	N+s3u3ocwfXLGCfOgeTY7bNb4mtEm2cI=
X-Gm-Gg: AY/fxX7CAMvQuL+gr4i3TxTWCau67PO5bEEt6TSKVvlD2iIlqHBVBqG7pH6r80t9jPh
	t4tBZcQ5I1mAPl6X6hhSozIb3rKTkiNAMsMKPUApegHr3/oA5zeqoBDZ+tAb9h1eIa9PmL3trC3
	qhuN4PGW316TIdrqt3vvBAiyrwRMm1cS3HeoXQ5ZULp/iYd5eoUmU/DKIVVn0jklEdPPJn0cxdj
	9ypb9XnuBgwsJF5c0jqXcu8ZVWz4vXhhQkXz0Xuay/2RYwTAw9lluJ0RJ2OzGY1HGLcYEvmmdON
	Mn4BZRqT7c93FxTFFW4rzLeTZWxL
X-Received: by 2002:a17:907:7f8e:b0:b87:6f2:a486 with SMTP id
 a640c23a62f3a-b87677a7f8bmr249654366b.31.1768409658230; Wed, 14 Jan 2026
 08:54:18 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com> <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 15 Jan 2026 00:53:41 +0800
X-Gm-Features: AZwV_Qjn-RSslqq6wTqoEnFMFejeapaNcVrbMiSJKDsO_29p3k_5tRBK6xPtM6g
Message-ID: <CAMgjq7AUz10uETVm8ozDWcB3XohkOqf0i33KGrAquvEVvfp5cg@mail.gmail.com>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000007f60f606485bf5bd"
X-Rspamd-Queue-Id: 5001F180003
X-Stat-Signature: ddfx3n4wx9ixqc46gbxa5r4jzzc7inuj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768409660-589524
X-HE-Meta: U2FsdGVkX1/0WhU6EZuEyXmvUvnaHrpwVW26Cp+Rzk25L1SFSSP9Hq/Ta34jlZ5jDIGFoR2ajmz6DRGQ9hiSrk9DoOjuJkDjUXn+qY6XWbn/O1OMfSQEo3hAkAWMCIXXrrQylaQ77r7ixVyJDBSnc3jo+yZZoFLsiYf7KLpeKGh4T8aUWEH0aWwO/7CNxiSLN9y5QUkVCz7Ioi5+/VrysrL4HnLTdfGUdphsbdMj5enONi+Zn6l4tBLmv8khvbGU4gDUPqoww5itM7l7NgAMVKJ+pBdheYTcMbBH1UWwvcNYDNqol/RMVqV0ySD85pK/+7FN/BL6rAAVLi1LHaW59ZJ8bcTENQM3Zcck/9jnUyRZXazr89WNPe54zdchnD62E9w/EmmNSNqkF5lKHvM/2SUTsSbgMqsP6tfy9Q2sUxpANumuBsUgqztSEvQrSPl2cbfkWKjv9zpebYT2l72nIltafO75tR6UXHzMq5tCr41d4d5HUkxzqY+WeDdHfLp9yuDjn2LUr36Tpr6Yze81RMTC+EZFLgWJtebSlNglyGqAf2KaKMKuFsUzKU2icacW11nRqDM1KrLa+dlIBZM9sIfZTCTCVf50AohJnm+Hl/uRy6YM2YrXS/rA8xpvAj/eFrpxGUf0N3AkxvGXXQcPhMLaN1pWlNcA0232do0RDh7xClPc28LiQ0lfpa/zmH8/8M7F5U5Mh1ibaR/xkjDHbdRoF2Y5/GNCuZvSgH3jatKuYuy7USzQBJVkQYRUozAs46jIUo2ymJfWUtQgeU+YcUak2nlI02nlhYCv6piSTS5eDL8YkHQ1vca6u+6KHnUSJ6JqAsqvWKdyRoC8L2XsN0ir/7Vv0OwjL8RLIgMsq//O3zKj8ib8lTz0EQrG1I5CxFhLIySEcG21jmOnGxJcvn+p0ESasmFjl3Y/pO86onDefHRsqZxVrmq8elrUci2loQoKiYI1JMDSiAkZ0d6
 cWwU4LDx
 Gyb1C/PB/5d2CRxsOQazNkheuWXZOawqiosjWIu/c+ogOBcFUxIcVGV15y5sL0EK0jXCPeZ0KEKMQbWZ8PARTWWmgMPvlvCiOXIB6F2POi3hSdKbVtsW7VqqDSuFbTFYSHxqlZIagggfso7r18rDd09XbXl9GCDHxiKX+36guapddjBA2w4ckku6Z3RtQn5KBQErzlhIwl+yqQXRWwF72ikDZRCq//nWTIYu+H6JagIuLI1lCkV5KLMQB+bKQPgHl++5gQY8SsTAG/qz4HqxlCeP+cTbxT0tJpte7piJdkJ1UvvVqiolH80TSe2qrez7RfNAIKwCC61T/ysqZydDdRdqPNl4+G1XyFPhTQkWrgl8Hu0inJUMjelq9gAegGlFlZjJmFWbZdUJJWUR5AeUT4KWBpixxBEovGbWv3xQ77ttmq3XX3vkE5QkbQEtHtN/xWu2FaSJ1Z3pG5jNBFH5o/skmOrKwM4aRnVdX8IFZ5Y9W37d/ppQS2DdUwLtVd2JXgDWYgbkOr8R55OmUntWMlRTe4qvQoY1tswRsfNE78cYgKmL+C3/s3OBuPxEyE8Px/We6sBYsSPY+BkLAQyekdGkVz65Fn+bOpN34p0TG7es6lIDk5bU0reLqMaATJOBN+lxiJaBHTzBL9eAN2iaFZi1iJP5J3AW4e4ypzMTA2zI0lr4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000007f60f606485bf5bd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 20, 2025 at 3:45=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> The current swap entry allocation/freeing workflow has never had a clear
> definition. This makes it hard to debug or add new optimizations.
>
> This commit introduces a proper definition of how swap entries would be
> allocated and freed. Now, most operations are folio based, so they will
> never exceed one swap cluster, and we now have a cleaner border between
> swap and the rest of mm, making it much easier to follow and debug,
> especially with new added sanity checks. Also making more optimization
> possible.

...

>
> Cc: linux-pm@vger.kernel.org
> Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Hi Andrew,

Is it convenient for you to squash this attached fix into this patch?
That's the two issues from Chris Mason and Lai Yi combined in a clean
to apply format, only 3 lines change.

There might be minor conflict by removing the WARN_ON in two following
patches, but should be easy to resolve. I can send a v6 if that's
troublesome.

--0000000000007f60f606485bf5bd
Content-Type: application/x-patch; 
	name="0001-mm-swap-fix-locking-and-leaking-with-hibernation-sna.patch"
Content-Disposition: attachment; 
	filename="0001-mm-swap-fix-locking-and-leaking-with-hibernation-sna.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mke8ymuo0>
X-Attachment-Id: f_mke8ymuo0

RnJvbSAxZjM0ZDZkYmUzNzhkOWZlMmY0NTQ0NWZjNzkxMjc1YWFlZGI4NDgyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLYWlydWkgU29uZyA8a2Fzb25nQHRlbmNlbnQuY29tPgpEYXRl
OiBUaHUsIDE1IEphbiAyMDI2IDAwOjE1OjI3ICswODAwClN1YmplY3Q6IFtQQVRDSF0gbW0sIHN3
YXA6IGZpeCBsb2NraW5nIGFuZCBsZWFraW5nIHdpdGggaGliZXJuYXRpb24gc25hcHNob3QKIHJl
bGVhc2luZwoKQ2hyaXMgTWFzb24gcmVwb3J0ZWQgdGhhdCB0aGVyZSBpcyBhIGxlYWsgd2l0aCBo
aWJlcm5hdGlvbiwgYW5kIExhaSBZaQphbHNvIG5vdGljZWQgdGhlIG5ldyBhZGRlZCBXQVJOX09O
IGlzIG5vdCBoZWxwZnVsIGJ1dCBjYXVzaW5nIGlzc3VlLCBzbwpwYXRjaCBib3RoIGlzc3Vlcy4K
ClNpZ25lZC1vZmYtYnk6IEthaXJ1aSBTb25nIDxrYXNvbmdAdGVuY2VudC5jb20+Ci0tLQoga2Vy
bmVsL3Bvd2VyL3N3YXAuYyB8IDIgKy0KIG1tL3N3YXBmaWxlLmMgICAgICAgfCAxIC0KIDIgZmls
ZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
a2VybmVsL3Bvd2VyL3N3YXAuYyBiL2tlcm5lbC9wb3dlci9zd2FwLmMKaW5kZXggMDM2NDg5ZDNi
MDFhLi4xOWVkN2JkMmFkY2MgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9wb3dlci9zd2FwLmMKKysrIGIv
a2VybmVsL3Bvd2VyL3N3YXAuYwpAQCAtMTk5LDcgKzE5OSw3IEBAIHZvaWQgZnJlZV9hbGxfc3dh
cF9wYWdlcyhpbnQgc3dhcCkKIAkJZXh0ID0gcmJfZW50cnkobm9kZSwgc3RydWN0IHN3c3VzcF9l
eHRlbnQsIG5vZGUpOwogCQlyYl9lcmFzZShub2RlLCAmc3dzdXNwX2V4dGVudHMpOwogCi0JCWZv
ciAob2Zmc2V0ID0gZXh0LT5zdGFydDsgb2Zmc2V0IDwgZXh0LT5lbmQ7IG9mZnNldCsrKQorCQlm
b3IgKG9mZnNldCA9IGV4dC0+c3RhcnQ7IG9mZnNldCA8PSBleHQtPmVuZDsgb2Zmc2V0KyspCiAJ
CQlzd2FwX2ZyZWVfaGliZXJuYXRpb25fc2xvdChzd3BfZW50cnkoc3dhcCwgb2Zmc2V0KSk7CiAK
IAkJa2ZyZWUoZXh0KTsKZGlmZiAtLWdpdCBhL21tL3N3YXBmaWxlLmMgYi9tbS9zd2FwZmlsZS5j
CmluZGV4IDg1YmY0ZjdkOWFlNy4uOGMwZjMxMzYzYzFmIDEwMDY0NAotLS0gYS9tbS9zd2FwZmls
ZS5jCisrKyBiL21tL3N3YXBmaWxlLmMKQEAgLTIwOTYsNyArMjA5Niw2IEBAIHZvaWQgc3dhcF9m
cmVlX2hpYmVybmF0aW9uX3Nsb3Qoc3dwX2VudHJ5X3QgZW50cnkpCiAKIAljaSA9IHN3YXBfY2x1
c3Rlcl9sb2NrKHNpLCBvZmZzZXQpOwogCXN3YXBfZW50cnlfcHV0X2xvY2tlZChzaSwgY2ksIGVu
dHJ5LCAxKTsKLQlXQVJOX09OKHN3YXBfZW50cnlfc3dhcHBlZChzaSwgZW50cnkpKTsKIAlzd2Fw
X2NsdXN0ZXJfdW5sb2NrKGNpKTsKIAogCS8qIEluIHRoZW9yeSByZWFkYWhlYWQgbWlnaHQgYWRk
IGl0IHRvIHRoZSBzd2FwIGNhY2hlIGJ5IGFjY2lkZW50ICovCi0tIAoyLjUyLjAKCg==
--0000000000007f60f606485bf5bd--

