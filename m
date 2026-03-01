Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0280FD0047
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 18:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C526B00B4; Sun,  1 Mar 2026 13:58:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9D86B00B5; Sun,  1 Mar 2026 13:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BBBF6B00B6; Sun,  1 Mar 2026 13:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B08E6B00B4
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 13:58:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8AFE0C1D76
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 18:58:41 +0000 (UTC)
X-FDA: 84498405642.01.9D3F319
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5E430100003
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 18:58:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=TNE5sxKp;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772391519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l52JBcX3wNE7nfMsvSTEDtavkDC+E0vq2GmhRE/LgKA=;
	b=n5AKb4JfzMjj0Hd4EFqTfWK0ihsgmsHV31cEIWQvgFFT8zultET3sbl/unrAyx2n1EvV/D
	fSpGiCfMrftAmdQjvmmilKo47/SFCiDy70pbKugqlAIaGaI4o9K9rRxmaryk+0uQ33BEbx
	1grdyuZnvQE3pUG7tqFY7EfgLAkTF3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772391519; a=rsa-sha256;
	cv=none;
	b=nKmYAbRd71knTvQcTlnSmIuIMIa0BO2IZMUTmZw5b3RT0h4sysm88KBWI++fEhctmqP0bF
	gB4FCB0yy6whEpS8pgKx7HxXV4F47oOMISLMfQ3qVEYjfV3qe/WhlX5kNhY8cIhrVsbu+j
	SeuymqOflSxASMMAU+zccBgzIFbbto0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=TNE5sxKp;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65c5a7785b4so5420926a12.1
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 10:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772391517; x=1772996317; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l52JBcX3wNE7nfMsvSTEDtavkDC+E0vq2GmhRE/LgKA=;
        b=TNE5sxKp8BQc60JAWwS7r1bY4HqOghaU0b/uB9LTyZCF6vJdfNbNp9uLwmXjAPd/Sm
         u57A8HafU0RdqQ25zIZkm/MnjEqGT+dFGpdt36m4Hh81VqmVIBzehQIyhsmuJ7ZMvsQy
         P13HzcfiMibr2cHnEzazhtlPkzDGEg0hICklQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772391517; x=1772996317;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l52JBcX3wNE7nfMsvSTEDtavkDC+E0vq2GmhRE/LgKA=;
        b=hz8aj72ZBLDmys1g+ykYBA9wehfjDQHqj65XbmVcJv42i4a8cDgKWNChxe+teWf/gl
         bSgkBdL/vaMK7cwfOxHnOZprkJf26CwQ/AMLIjrG2csTglc96vewy9TjgTXUoe8VG/Ix
         iMICZ+b4cbuEo7NhE2ywohGUPKUdzUMqNlirCdMWPSYfK8LHZvAAyRYRnMQZ26pDP7qf
         vJJrxJ5macqzHmMFXSYc0sgXS2JDP4ECHgSpJFoJ6k6nMZDYv4hMtYZhaE8quLE8EYfq
         taXI+2CVePZ40T/vlUgRY7BVmvwumuWLObC812dN3urZakAIRqQyiG6Qa/oLmWfT3L61
         Qw5A==
X-Forwarded-Encrypted: i=1; AJvYcCWeS2vA+qwFPhcYhCFXZQt7iWyTZtxcQ9sH7nLkWP9RwJZ3j6LxiI/l0VtdJD6SXXm/gol6VdyTZg==@kvack.org
X-Gm-Message-State: AOJu0YyUlFGs+aQ6GoiSEAPCK7BlAesteR/WRzsaQy31tbJ2QuU4fBxu
	i+16SCrjsjsR15F0E76Hizlmm5nvCHqoFFtxpl1wlOTHPK/U8ckYsxHvqQaNS0XY0WdPWPaqBMO
	z6sQW53r8Pw==
X-Gm-Gg: ATEYQzzGJvxE5vTWi95Fluf1+PhyE9ZnwfksxJ0HYWmCzHAZSstxfZ/WvzKpszD0qHW
	RrLQ42sUsO4BqXPQqH609g+Cat7ncov9kfGL3oxLtmwdGZnye3pTEBjYuvG88tauSZRc5U4TY0m
	isoQHCJZ8Q0uJHOfVam8CJzKvqTOZkHJDgh4khJQpMUZ324jHSoFxCLMtxGGZjkitJTchIrn/e0
	r5Y/A/cLb/j+EVJCVo7IVAchZuQTwXLS9cSsmiEgCWmYnZcY/pfCmu7tLDcqegEI6gr6JQCuJyH
	ALkaTOgPcHOCxka4W/Q3GAWpVv/XrvYq+4Fw9VG3TZAEz1igdJ839doXU7ZC11YaQSL4ei2Cwss
	cJQm9vj61DrNb5Ygy+SU8O60XdP4RaZiDTYbczCL9Y1OdkzT1M8IIlESIkwa6TZizajRv8azBjf
	rSHbjUsnzGxQJ77tOBXzqJztzWuoybx5BK5dPGzCA1/AKfGOaifvu/sly21qorkdwM16I1NGE=
X-Received: by 2002:a17:907:3d50:b0:b87:d92a:f6d with SMTP id a640c23a62f3a-b937639b944mr648547166b.14.1772391517315;
        Sun, 01 Mar 2026 10:58:37 -0800 (PST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ac73a5dsm378095766b.25.2026.03.01.10.58.36
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 10:58:36 -0800 (PST)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48371bb515eso56367405e9.1
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 10:58:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXKOZJluR1xsHWkmDStbYc5zDIFrVB1iDE1DB6dxeyNBvx4irX2ObvlwGBZBdXz3K2ES2ad6XhavA==@kvack.org
X-Received: by 2002:a17:907:a01:b0:b87:1741:a484 with SMTP id
 a640c23a62f3a-b93765630c3mr683986366b.43.1772391194481; Sun, 01 Mar 2026
 10:53:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <20260228141941.f6fec687aae9d80a161387f4@linux-foundation.org> <CAHk-=wgfs7KqS8pD8F9F9yC8jwSgQtmifytbmmXVfz9xXrQzuw@mail.gmail.com>
In-Reply-To: <CAHk-=wgfs7KqS8pD8F9F9yC8jwSgQtmifytbmmXVfz9xXrQzuw@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sun, 1 Mar 2026 10:52:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgOxtAFf5XeYTcoUHSpWfMrgZaXKc_hrmqt6yKBdr=3Zw@mail.gmail.com>
X-Gm-Features: AaiRm53wUk-j7BSu1BHekZwDQRwk7QegjDnqY-vnwFgpDSOB5GFu8_5dX2_z9CU
Message-ID: <CAHk-=wgOxtAFf5XeYTcoUHSpWfMrgZaXKc_hrmqt6yKBdr=3Zw@mail.gmail.com>
Subject: Re: [PATCH 0/1] mm: improve folio refcount scalability
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Gorbunov Ivan <gorbunov.ivan@h-partners.com>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kiryl Shutsemau <kirill@shutemov.name>, 
	Dave Chinner <david@fromorbit.com>
Content-Type: multipart/mixed; boundary="0000000000008d2745064bfafb4a"
X-Rspam-User: 
X-Stat-Signature: ooek885iywaq5s6zmi3r5c9r6gynq17z
X-Rspamd-Queue-Id: 5E430100003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772391519-59717
X-HE-Meta: U2FsdGVkX1/5lqYExIy24Ti0jQjDsRYzzroDlpna2Zm2KaBGfyJAfJkvXDf9k8wD1WiZJiFQxHmxXIx9l197Fy0+K/YFR9TGZbCS38vrg+8ibOoKqpMaRarBv6iO11zrd0q2L9jB/toEm1M9lSpztl66r1ZTp8eEYdkORYWmY2wOWeyBCowY9f/8l1DoKJL+94wV8mzOzQrZ74E3oYVf7D36I4ytMBFHDZWMQVdBkjhM89XujcGuaTBn81oVDz9xfGQqWnH920vjASps6hjUATsrzAJ0MNQa/37jIIju9zTIM/vTw3Izgnjv0KTXlbkyVr3fcWwHU8ZL0SsxLtMNag/TMR+qn8l4zOZ6QX3S2+l15aLrY8AamFnzDI18PzVNwNi/WwSpKT0tWq3P/p2S9QnfJvlHffr+IANmyzzcWnW6jWUl8ugTcKO37EP/7j5KNp1EMAC7F1IODxoFwEtJEufEOdw8tUCaZWadOKkQ8Itrf5PXAh+LQWl4nTcpXDjYSD4XNb6MgGC1KROVFk90b7pgdR+AEUYxwfjGIsykv51JfnDNIngxdh8H7MqR4kUpnUPFvngz4r9fmv4QqnQ+6yBkGNZ0slz+/lBW4TTYAzP5w/cr/nlWSjh/03rZCxUMzMYnlmRHmRdOOi8mUkkuO6uaaxPG8ix9Z33QzUeEDCC8ihaKcNZtaCFB8vniqeIfURnNjxs0UEUvLNhxowXu2qF+rSIwAr5PFs/6gZJhEbfiWwYT8JoeSZPKqjgoP37BRT0FhF//BANjyGLHR/rq5mYy0OGTrha6bNAlNfcjMQeOKJcjpi0DCZxkBaA4R4pBG29zmuWg8du6jCy15PTfaaVWk9WW31ha/6G5WSI5/+Jnr2l9oh2PWEN6ka4+D+7FQoBFc0spVVKz/XV8S5/zRPtB7yEx+kgyC0vY3QQAcKKl2aRTWbZrVSqQEabaBu0hKKmZyyGDbZ07m5MdIzZ
 rsbAUAAn
 QypXnPLq125XUzTsx5KQxgV2ZvDvacrBZhilqzJ+7N8QmKapu9B81zkkNi1T/hc0r2B6UESAB00LlWNu1GI8PBoOXShm8dkzJeeQrL16/ttIucixkn9cbclFpIkwgoriC8AAafEWM/Flx/D7qEMbwQihGJilbPJIUJBYBH/lIpxE3Aqav2VvdDjU+Yw7TZHUd/2YS9WctegyFixkLZHFvUZj3wyFnt7WuD5OWOtK6e1k8YZOG8WerLPVWAVav4vjxmPMFcXM+m/4XeC/RKU6mWW5qEmsmKaojCzaT5piuJouxdF9LAmqs8hL3PTnKGowZt0M7qfDn0Rw4sAbCFgItim1tThLLSHpwUW9FaV9Kefu+QttB8SeoD/iwo8KEYGlGpPDp6gIzSynacB3b5W/mpYgamW2v+KcRWGB+PrvyfwqKM8dbiBzn6Xb2rYyr7t5EqC+Ze9lI9W5bkHTtjR1yDoqP77JK/jRlZeECbT1DGBDcTZ7ggM8Ma/v+rNA6vw+QVdDz7BOODFLibUMUjAy2M7V+iExS7zOUhYy3+tz7flpnZv9WmF33zKPPRW1jYI/DBnf6cDYdAspT/5MPW2LLM8mXnY/z/KhizM6GSw5T00ervmBgkrHQwKW55A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000008d2745064bfafb4a
Content-Type: text/plain; charset="UTF-8"

On Sat, 28 Feb 2026 at 19:27, Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> This attached patch is ENTIRELY UNTESTED.

Here's a slightly cleaned up and further simplified version, which is
also actually tested, although only in the "it boots for me" sense.

It generates good code at least with clang:

  .LBB76_7:
          movl    $1, %eax
  .LBB76_8:
          leal    1(%rax), %ecx
          lock cmpxchgl   %ecx, 52(%rdi)
          sete    %cl
          je      .LBB76_10
          testl   %eax, %eax
          jne     .LBB76_8
  .LBB76_10:

which actually looks both simple and fairly optimal for that sequence.

Of course, since this is very much about cacheline access patterns,
actual performance will depend on random microarchitectural issues
(and not just the CPU core, but the whole memory subsystem).

Can somebody with a good - and relevant - benchmark system try this out?

               Linus

--0000000000008d2745064bfafb4a
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mm83pnxn0>
X-Attachment-Id: f_mm83pnxn0

IGluY2x1ZGUvbGludXgvcGFnZV9yZWYuaCB8IDExICsrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdl
ZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvcGFnZV9yZWYuaCBiL2luY2x1ZGUvbGludXgvcGFnZV9yZWYuaAppbmRleCA1NDQxNTBk
MWQ1ZmQuLmQ4ZTRmMTc1Zjc0YyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9wYWdlX3JlZi5o
CisrKyBiL2luY2x1ZGUvbGludXgvcGFnZV9yZWYuaApAQCAtMjM0LDggKzIzNCwxNSBAQCBzdGF0
aWMgaW5saW5lIGJvb2wgcGFnZV9yZWZfYWRkX3VubGVzcyhzdHJ1Y3QgcGFnZSAqcGFnZSwgaW50
IG5yLCBpbnQgdSkKIAogCXJjdV9yZWFkX2xvY2soKTsKIAkvKiBhdm9pZCB3cml0aW5nIHRvIHRo
ZSB2bWVtbWFwIGFyZWEgYmVpbmcgcmVtYXBwZWQgKi8KLQlpZiAocGFnZV9jb3VudF93cml0YWJs
ZShwYWdlLCB1KSkKLQkJcmV0ID0gYXRvbWljX2FkZF91bmxlc3MoJnBhZ2UtPl9yZWZjb3VudCwg
bnIsIHUpOworCWlmIChwYWdlX2NvdW50X3dyaXRhYmxlKHBhZ2UsIHUpKSB7CisJCS8qIEFzc3Vt
ZSBjb3VudCA9PSAxLCBkb24ndCByZWFkIGl0ISAqLworCQlpbnQgb2xkID0gMTsKKwkJZG8gewor
CQkJcmV0ID0gYXRvbWljX3RyeV9jbXB4Y2hnKCZwYWdlLT5fcmVmY291bnQsICZvbGQsIG9sZCsx
KTsKKwkJCWlmIChsaWtlbHkocmV0KSkKKwkJCQlicmVhazsKKwkJfSB3aGlsZSAob2xkKTsKKwl9
CiAJcmN1X3JlYWRfdW5sb2NrKCk7CiAKIAlpZiAocGFnZV9yZWZfdHJhY2Vwb2ludF9hY3RpdmUo
cGFnZV9yZWZfbW9kX3VubGVzcykpCg==
--0000000000008d2745064bfafb4a--

