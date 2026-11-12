Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CC1606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UISkgiB6
Received: by kanga.kvack.org (Postfix)
	id 6F76E6B05C7; Thu, 12 Nov 2026 07:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8046B05DE; Thu, 12 Nov 2026 07:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5490B6B05DF; Thu, 12 Nov 2026 07:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1438E6B05C7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:34:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F39B8A058C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:34:02 +0000 (UTC)
X-FDA: 85426409124.11.6CE2BFD
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0DB9420003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:34:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UISkgiB6;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794486841;
	b=688a77CfLbfWpqyDbtB1Zkt5zqUeMlvSa3XeaH10YDEhk24U4Xn4g2EfGDGCiqHcUM8Hav
	Pgy2a72yTKkdVzIEi+7g43O1oMNjo4Fhdm6inzzJuD4LPN7a2BzA/KXnoh3WcmzO/8z3rR
	aJaWtGBTz2V7rQR1ZCpF9oBnOjX3XVw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UISkgiB6;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKmlHtAvoB0yUtbhRvNeCYmD52AQBw/3HL4TeYlZEfM=;
	b=UvkAvssiEyTiJSvsFEE1wGT49ItDuqbib1Ypo/bjEqDKqkDASXHwfA8P6TNNSAp1tE1UiV
	T8rej/fzL+b57FNEDk4YTQzjHUqhZp92EOZbu0u7VZH0W/28cTJRW6RJeZstbrbRr493E2
	7uzK4Qb17knllyG1Ms2yGTmmE3ITAZ4=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-49134c8509fso3468306f8f.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:34:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794486839; cv=none;
        d=google.com; s=arc-20260327;
        b=pTrgf6/LJ6OmiE2kS1jnlTSG5fj6MiXo2ayuj++GMKOlvV1aoFWZQ8TEJHZIgSgohF
         EoQcE4jYkS3/bQCZFmQxS3HyNk90lieAj4JdZiQzdmRHJvv2JsQHR19rVxdOC1yEgjq5
         dt6wJvaVd0glixoER9oIbSSsN2PyFteZ6KekRdHJPv9TCVUThXbYONg676rKf8snnq79
         jIdPnXQPQim91gmaD4+yxMRBPYxVJWIGOwkDts4msM40+wsiGwZ6j/c3QecdlFSXF7o5
         AYH1XS2xHTsuVRXHfxD/hXK4p7PtxE3PX+TqDbCO00PEoBfXxR27n1atDkL4/5ptmkqH
         3lLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nKmlHtAvoB0yUtbhRvNeCYmD52AQBw/3HL4TeYlZEfM=;
        fh=nvbJ8VOlIKIu7ubB8R2PKQ/VS26U08ctevfLNKRcuPI=;
        b=o3dkyuRNM71Z9r7/ZRpB5x3DVRVODn/ErcI4PNNfJA9ThizU0n+EzFVu2qHMCRMMPh
         KFnLvuWt+5NPypHKw79OvtOT59d+I++u/rIvg+jqmTAhhOUlO0HqKZGZ93imSD37LdvW
         JkRd84Be5Ye4/useF3gAU7qQbOjNl15ZplsGheaubKo+lzckfdMUsXBRsSNRPSCMylzx
         rMKRW12H1i6meWL2dzmH5epnIY1LzFvW1z3V8NnFkMmvJ45GkHXw0fzO+SO+sYDZvfcY
         +4M8iAz02PWJ7yTEpC+CAWM4WBiyP5CGYMdtyz5K5HrlCpRjqQQ8+g0RXqTnmvL+R7Be
         +K0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794486839; x=1795091639; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nKmlHtAvoB0yUtbhRvNeCYmD52AQBw/3HL4TeYlZEfM=;
        b=UISkgiB6vzpuoio2ZIzJz2RRT5xGUpglDDHYSShgvqbEnglmnURT2mpmh4Gyr7D5GL
         Ek5LqkgTVJt84jwfzci/jXoS7GnJ8jpw/tzNrW5kC94TQwzxeLx1+6M3oqT7sQF5vEbA
         FUCU5iK2CJCNKLUkLh/F6lWwt77tCX6HujeR5pmIMdXvTx33fULhhYJAdiltZs4ZbmpW
         1RxMJWYzFkpZo7OyLZ3l4oUoiqd3UmgSrclEqd6pfWl1GjpZgkjml/sIify5UYg/rACi
         PeQEXN6e2wMmQzcqhhBPofhnt4qTv9QFyXGraUFWZxDqsSU95Bj7+AllKlQ5H2oEhbf7
         oSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794486839; x=1795091639;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nKmlHtAvoB0yUtbhRvNeCYmD52AQBw/3HL4TeYlZEfM=;
        b=Gd9+tIEgrSwDMepxOftGdb+godsbeCVQKjrzkrYH01MLFUefYO5rhhf5XpUB1m8BDg
         Ueg7G/WNeoLR2EUSUR20ojSq3ei8kOQxW2dPygtHizW/87Wvqe2C2J0bKdhL9FRtGQuJ
         nBrHUlbBjOZcScoQwhQPiDdakp9srhExpfxZ5o/VYmNJ3OMwBHur4YqQ4z6BVCyKErOL
         osB+eHtHO/CbXngDGJw+Yj8ymVHIqODRIDTkBdQu4lz3o6ksnp9Vb5W3H2Om7zwEbb7A
         Q7voyJu0oLevSYsTf6PkHCfEpSugAFb/NM7xTBNS/6wgHf6XFJwTU/WmnKQq3MB3uRYE
         4mmQ==
X-Forwarded-Encrypted: i=1; AL+hErHKDRl+d1eXR4hJpGgJk2A/5xwnAnACRiEjX3tg4UxQBG6Iv5Hcq2NdYmdm95hE61aV7y+DLlNRhA==@kvack.org
X-Gm-Message-State: APuU4Z/9GDpjCHsyFD/CBU/0KgoA+Jf+sxADDuTOBLCSwd/Gc9rTb0uu
	8phPrgvgFNmBbukxaMngrZ9qGZ1GMfYkUg55jCwlKqw033ajLy/HAH+J+ginyo2ttDhSoTZW3CH
	gXmYq1XLQaCNm4rvgqS2qT2rdT7dN2DM=
X-Gm-Gg: AYBFou3S48mWYvUpIyglOuNCTZIgXUaX62qjmib5kWq+mRj9wFu5W0Hxdo5OFPN+4Rr
	o5ItmHgJbZW/rtTVYF0gplqOWQld8/fNzunpVcLPRdvQlD1CPcZZzljjI1gnh3Jqmh3CsrQ1gu3
	g9RGHkcQYWiMcLFqZlyXl42ut8ph1oKjU4yXCThbVEMcWkEWCd5owMYPgxcGJmX/c03aRu5zrQX
	nCD9IPXgJoE4yrtv5m9c8HJcdp/B6fal70YLOFL3wR6fHpwWRPDR2e0ScMlugUJhkKW+K9Xqz4M
	kwD+1Rt0hsh3W0vuEPlsYcZJ46EyVkhG0F1Ga/yhxP/pRSsu/3OYQHFiTK9e2hKReofy110eNAw
	VKzr9EcE4lqQyV6+ovHdK2+ZpugZhOXQncxsZmc7jLZFOd5s5yv9j0yPVx+qUUl/KAUlWZhkZFL
	S7Rv0mxaDNdO4ht2ZmsotgW6w8WlCf11egWQKLSu+aNKkcwn8gg7MLvK3LPp4Q7gZtFRnUeMH4L
	A==
X-Received: by 2002:a05:6000:4310:b0:48e:870:7791 with SMTP id
 ffacd0b85a97d-499c6e96824mr9018890f8f.26.1794486839273; Thu, 12 Nov 2026
 04:33:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org> <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Nov 2026 05:33:47 -0700
X-Gm-Features: AclHuK_RzWviJR9jmvlK9oBAFygOMVFIIWMHi8nCFGJAgeBhxOkAfyb2dvI3XUA
Message-ID: <CAKEwX=N-YqgrZTpoxLoKYTnxT2QR4Z4_ohw+SBR+M7CErBDbOA@mail.gmail.com>
Subject: Re: [PATCH 03/13] mm: cachestat: restart the walk after each entry
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, 
	Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DB9420003
X-Stat-Signature: tkjfsmsxcmp4abyk33mi7hiq3ic8qhou
X-Rspam-User: 
X-HE-Tag: 1794486840-111043
X-HE-Meta: U2FsdGVkX1/6yHuPNNQag7YnIcsFrqwz7bzZyR20+4ZYMyMzz5WY7JbdxS7uIaoNXtRD9hnYTQExOTWILZy4wvIwbMNzHAR9iPHEamwyCzQUQMQvslDHdN8nvxk3sS2ncN1/RQ8+OhEJEW/8nHZattMVBsRJXPpLrxtb16FQYy+R6TiFIKjvx+lbW8hVYfHtul6tloXQ5yRrxHtFPJRDUAU/mZGSlEIAGsOLX6hWZ0ffKdZfr6IRzVjMIgX8qsLasjJeINtrXERnIesVLGJoUiy3VXE6guZKV702CW4qilkBNjSddkCq1tzvpN9FcMYgsmSvp9mrQM2mj59+q9rqrSeOLF0O4+DDHKMc0FiRIw8o4KHer+rK/+k0LAAqpslnnwU1CAY/E2lXrkUn6U8WAyQLLhaYs5RLJ8wqUZ2o0SOu8OEn3vau5NjTaYH0jG/fr8fhzXwFx7VltN+bPnaKRdizf+mA6Fk0DqiIt59aogeCFdxPBLhs3gBMdP5pGDYt33ip29CiHkVECAUY4H+o7HI0htKxX+ZWGQUcm/P6e7JgrnH4UCSvOibijPjueE2Exrauu8CFWL+SUeuQKlFnPPsG+4lCeoJUfpFx2A7s0N5YmyfD62FJOM9gtFS/11K+qXnUGNUEKdYXTh/Cl8/XUXh9VUAmFTDMlNr7FIkisb9S5BauY0KYCBfQIADewKCUlEQHwdLWApKgfcvyzvuDqr/x1rLDxGInly3Lvqng8AvbVghXqTFfcvpmEXgeM8wP6DPWQsknYvj6299LYRXMizmOWlAVmsc1sQ5/tw3rqauoOrJMtwX0l0G+UguobCQuq5mQNVZHVEZsWr/6GAH4Q0+w+xn9ZlARq3AJM8131RLLwTakvB9Vc2Rbxc4iw7okXbD5aXSxSPJ8UFWfpUcxCAD/ln3mZckZkS8hsMZMg6hPpPFVDtpxZsXuKJLywDma2VKa8HbzIWzrH40a0WT
 h8P5y9jc
 43mXPwaoISPLIo7Xrb+gcEiCHhO9R+Djfk02gXZLNsWEjEAoG/KMrqJAJEP7ChVKYL3kC2a0Ggsja8GpLoozH/FnqH0sUTqMVxy2UVLx1+s+LLLNJogWYU6ue6b8/MZpxYkD3GaSectNWsClXJkuWVbhuBSkVl0og0MEaQAUCD+A+boVnN6KzPmLnVYWIA2I8xMBjErnOA1pCCQzU+l6AIwwC940skBhfmW5QSKGgPLxurra5AdATe0x7/TYJSIZzTFvlpq1TKvzQ6uhwT1VBA+rV3YsJRwKTE4nYbNsd7kkH0D5mu3xRwRJnEgxBum805cYepQ/tXk0HPrImEfwNG+el7haUI7OBMrwJ14rX36sanvj4+MDogb194fOjvRNuFRc733awfc/N+gJGOYGaU9lxPoR7pMQcw0M43YxwBrP6MsdTj1Oe7c2FXZLICvMINgaHU5Mb+uAye66Bc5BpiyJYazKpl3i3z9g0/7rEstwM9WbubVlqv991lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:14=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> From: Chris Mason <mason@kernel.org>
>
> cachestat() can leave cached pages out of its counts. This happens if
> the entry that the call has just counted is replaced by a larger folio
> that starts in the same XArray slot.
>
> The issue is that filemap_cachestat() walks the page cache under the RCU
> read lock, so racing concurrent collapse/split is possible.
>
> Thus, an entry can be replaced immediately after the walk has returned
> it. When that happens, the next xas_find() skips the sibling entries that
> point to the slot of that entry, since ordinarily they belong to that
> entry.
>
> However a concurrent collapse_file() or __filemap_add_folio() (when
> replacing a shadow entry) can store a larger folio in the slot, in which
> case the sibling entries belong to the new folio and the walk still skips
> them.
>
> Consider:
>
>     cachestat                         collapse
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D                         =3D=3D=3D=3D=3D=
=3D=3D=3D
>     count a 64-page folio in slot 8
>                                       store a 512-page folio in slot 8,
>                                       with sibling entries in slots 9-15
>     xas_find() starts at slot 8
>     and skips slots 9-15
>       /* 448 pages are never counted */
>
> Also consider:
>
>     filemap_cachestat()                  __filemap_add_folio()
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D            =
      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     counts the shadow entry in slot 0
>                                          slot 0: a folio of 32 pages
>                                          slots 1-31: siblings of slot 0
>     xas_find() skips slots 1-31
>       /* 31 pages are never counted */
>
> Essentially the fact that large folios might be present means we cannot
> safely continue the XArray walk, and must reset the iterator each time.

Hmmm, cachestat is inherently racy, for performance's sake.

OTOH, it does seem a bit silly to undercount purely because we race
with an operation that does not change the answer (collapse/split).

Johannes, how do you feel about this tradeoff?

