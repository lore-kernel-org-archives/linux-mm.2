Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A522C606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hS+sbDqw
Received: by kanga.kvack.org (Postfix)
	id 950A16B00EF; Sat, 14 Nov 2026 13:08:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901606B05B0; Sat, 14 Nov 2026 13:08:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2E26B05B3; Sat, 14 Nov 2026 13:08:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AECC6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC9B8C0452
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:08:47 +0000 (UTC)
X-FDA: 85434510294.22.193322D
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id B32FAA0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:08:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hS+sbDqw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794679725;
	b=FTYqjcRvVzdOhGRm9nfnBC8adqDjJ+srqCGk+LhFfL890QdGwWk0geaFJ17Y35M+1fZ/XG
	STsVx066oxOVG9mNQELGkdaxpeWEqPNaalF7UqCShnUDM0bs+8/OsqkSZE0pLKIUg4fU0S
	ZEJO+GeXYmUrRA0qUuxl7T56pTvw9cw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794679725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvhLrxGhqHACKbn99b5AMFC48BGMEpVYG0nynwtl6E4=;
	b=dMN++JFNgtjONQmpprLM3OQJOUdQZ+xHgxybcXpTtxpFbLW5vD0WQbr7Qn5S7rQqHFZqBt
	tMgMY0k/9ySJiFP6CwevcE8M1x4fe8GmpNf22X5RlbAwrGhV8H+H9JyrAYWKkw0cdx398y
	oKPar9cfh3vf9WyCSBgyPhgoJWFxsbE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hS+sbDqw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb6886d30aso2176995e9.3
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:08:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794679724; cv=none;
        d=google.com; s=arc-20260327;
        b=mkxPs6QI/zyz6gLTamxJlLqf/SP6lQSxzsrzYCFfZXp8JiCxL7ENj68DzkuiAterJU
         fQT3LHsfMAMbGMlcUdUCFn7+J0MKQcliUzJvvAbd3SP02fTbH+4CupHZsTLdBUOrrpWT
         luSEkZJMpw2bUWhZiycr3LggQ10mJ37rwaj8WMsVp+xpPRlxwq+MZagRCRm3qh5AWBA/
         hHiSfS2+cDTF4D/0+Kawx9NCEPYGW8mtWBm3VByVxPofK0F6qe2UkrvpUGqi46aNKL7E
         YUe+SrgK5F7peRTk4r7YovRKMUhHe74LFdNZ67bx1GOgCI5VeidkLLPYc6M2u44/IsYw
         KH5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RvhLrxGhqHACKbn99b5AMFC48BGMEpVYG0nynwtl6E4=;
        fh=oOEJJlafCBwPEVdsYU1h/Pqzg+cjLO8Uf/Lst6gFhCA=;
        b=sZpu6+KqwmzoHAQfABw/i1ceosGlh/ncBIfcVCQMvLjkxoYla4srd2GNASlX9YUY1B
         kbCt68hkA4D24A3Fs0EcnHe45PzAk6KLncNljEafcPHv9uR+Sw94RM5OWYFVp6wI7PVC
         xvFKSl6d4CUly9K6CcC33MBBBWYgbgK3qVSgjk3to0a2UmeBykhZeUwnLuE6mR/8nWwI
         9e8peiDWKdIGD8qV3Orbcgu4M5qcmNqXLMpHaHvOI/cdFfsdCFIacRUGX9wqgYejGmK7
         X2aJb/n3QnwjazjqrxjbFAadfm9+UrUqySOVX3WFlPd4lVLD6G16N5e5jXCDihUnhaGh
         BHbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794679724; x=1795284524; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RvhLrxGhqHACKbn99b5AMFC48BGMEpVYG0nynwtl6E4=;
        b=hS+sbDqwtX8TLWJPyoXpy/ei+b8LmYjmmWCeOhebt1WVB0binZhKmwG6o4JJjq71sA
         YK4HtojyejeLK7T6WKMGibnux62G6sQZlktnOu/H0mle3PoD9xJ5YQJZ9JPwHLzSgoy0
         0bZ75RP/M/QzzUwMdKidMz9YgCehLpYirBfKBdBIGeC8/uOnL2b/hb+JPjYKnlaeMNEY
         w179L7ZEY0PQ1X/doKRxxbFS9yKkRuF3wBRT/2AU129XeP6/nOcRKW9gnLjcCJBzJHRt
         HCG4IWGYC4fA5qNec9j86YuHOEm408v/lffIiton7HWByrjHyoT2m4PIKn6ur2Kr+Z8X
         c4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794679724; x=1795284524;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RvhLrxGhqHACKbn99b5AMFC48BGMEpVYG0nynwtl6E4=;
        b=OCU3FNmvhpSeKzN7nH0uAJXbYZBLxQrEbLl49mY1n5L2tVq0w9+QEMAvFZpPV2zubP
         v8b7QamnwCKnBX671rfgWx1G04/z9/0N0XaRcgqfZ/2P2oXeghtCUpUVBi+c16f/bVwv
         jBqOYN2D7KjON+zyGeLBxfA9mXvKNYpPQ4QV3EER1c+v18o68Dv6J194jCodIFpjo3EQ
         t9CFJCS2UgBnhhnpcHhpKZFiEBSCmWqo10CQZmc7BgRw/XKXt+myw+DhFldu8WoBv5NB
         +Mg6xDRjdas90ftdFLLFNY/AcXj+BUq0oscfqcYx98bhHMNYQQoGH3OKzYyTFkUAVrS+
         0+rw==
X-Forwarded-Encrypted: i=1; AL+hErGVkUkKE/y9oYJf5TskAoCtalmh8pvGKA7JW4rnhVPWBBIgzYYVXUM0QgLqilttkMGHq17CQ20oFw==@kvack.org
X-Gm-Message-State: APuU4Z84Llr7KBqUEBJDg23zymcouC25WOZsc6DHIadWPgSXmY+2IK6p
	z6oUK0FfAoWquP8mpTTmi0C+Pj/HqQlh6DAnFeXOPNcvYW7RtN7CJOOTjZ0aLua7r8uyfCgiwZ2
	Ag4CiweIZIEjiJe5PnjqGTLxrjHQ6/GE=
X-Gm-Gg: AYBFou3t2RN38uSJeblwmxpDoUTYtG7N3TofyQIfzoCkokEjIKK4iPOn15tkrv1GRCM
	Cd9cQ18xWZeY/+IqzG74sOAmCotu3R3j+3QaYzm4Lqy1wRfBme27yHK08fT0LG7PzYjNMUuduBK
	bC/epineaaEO1TVQg8JzpMI3uPoxE5d6ySl74rdwyUlmZjV6CTUb/b//kY6jvePQENnIs4eBY8D
	Bufxjs8bhjH79/btKOf5Ksoqi+QjpjBgnCll0oyNiclhRzuSxEm1lQ3C2cJdMFJdoSbeME4zi7c
	4C7fYeBhH/e/lfKQOC9DLuebNGfP8enBo/37HOKooj+4QONSOK3hR8JtVq1Hf5LOlnV1tZ/LWeA
	RqNzy9rLMGEP+am6UY40jaCtSOEnqLC7ntcXinhog/J7j+GyAYoegq4ygEfCqD0SjA7oXIO3kLn
	2osNNXQAnWYnHzD/QJ2FO2/JSwmYqtdSmhRMZwBjfxlDSSZ+sT6MBV
X-Received: by 2002:a05:600c:b99:b0:4a8:cb23:f71b with SMTP id
 5b1f17b1804b1-4bb55a92e7fmr127107305e9.18.1794679723922; Sat, 14 Nov 2026
 10:08:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org> <20261113-mason-migrate-et-al-fixes-v2-3-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-3-50a2ed382b61@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 14 Nov 2026 11:08:32 -0700
X-Gm-Features: AclHuK_ELRI1TE67xJqn6AwyBkxgPS__XUAV3eZlpMOL_-YZzAJWxxy4oUoG69c
Message-ID: <CAKEwX=MmKuFwXpH5f8MtfJteqgs_O+xMUCNkNK4hxuAMpFUuVg@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] mm: cachestat: restart the walk after each entry
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
X-Rspamd-Queue-Id: B32FAA0007
X-Rspamd-Server: rspam12
X-Stat-Signature: cq5tuaqypi94oewjmke6edrdycncr8uq
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794679725-257362
X-HE-Meta: U2FsdGVkX1+eis0rpVAV6iPfLhi4rj7xcVtyIgF4jmTKb/L+8hy3e3LfoN9etHzGsVN07Q63GDz2S72TIOsRZ+PDlpDEa2CdY4w9b0uc9hpzQ1r9QwNgD4gBkYk+u6dix9as4y3g0nSQriIaFWPkAjJ61gu8V6VOkuIX9nuHf56FMNidlM3Duh9QZYzP3mGhJZqGZ7MNygaOfEzsJrTTLNj6znO71R/dKWmtslrM3YgJanFS7i3g5znFfbEUNe/ZOwCcPV915BlR5is2hv+fBB2cUUpH+2DFvSZg6YJtBXUpjyydRb9nYmn0oSOU/jcITpM599r6EK4RJbMNpaso5GPtgusaM+AQJkpTX7M9f0AhrCqIFVt5j4Gc4Eft+mDpXmW5yoptZcSdtwoV8hSV+B2rPvtTdjUpprhso4i9KGEPSyYgI5Ct8RtiF0GjAFFY0J3UZihweeHrXeeGZnv5iCUqQK9Q3++dGT6n+4ne9jc2Ssr9RiRh+zBBMP5x1qcxEtglWAAAOpxP897So9Q9jk7KddYJXVLu3Q4T/8gCo+vxxX3GPjKtcc/LrmR7aZt/9seY4dDhX93rVACARpgnlV2yjHMzb9WfJazZBSNpzT3xDFuW3uac74jgZuzELaHhNMolN+70BgjKzXK/FWUKaZrn7iLJP3Ap8EY8cmNu8awTqDNVEiuV1hbUGxtTKEnhqP8BisE35Yhzq/2WF5qV7SzazdxxLU+zJvG95NCpgSIBGZHVcWdISpdBKvbJzpg5sFMaPbkjH2o4zLk5z/vGe+qD98AV6i9HFCwV6Ts35qPWKtRpoyW/LYUOTtLmkPHYR2j3U2yPC14VfQYn7ref1+dVixkuqyScL33huNCpQ09PLb8BY7m3+QmamaCi0HV8p0oiiLtqxfZMdb/xPrHhkQK8gGBLYiawAssr5LcNJAqLK6mgiEEpT4uIsckd0KeypqUvKrxgmbEppZ10I6c
 8jzEHY5c
 FjSrYpNJijfN3hYlOIri2Aqe6mVUZcenB4nM+Rmtpb+jKrnd9p3HHEdyoI9Loi2StBfRWkijZ6wxtAsBmGJFYORpTVT175/Sk0avyKiP1YF2xpdvUaaH2iowbbfKZbTncYfrDeRyn3TufKGU89q89vxgDUCnFQ0qPjBREnWm+h+g7xe4HGTXkGnUTb9JFBNWCDOC/l57mAFp2sflBz8YdjsEdEQV154L3dxiH5gPhPRpnb6sZJzDyJOdebEy7s3aHQU/TztgUoNyfFmo8qNwyAoICyg2dnF1GoDCv4ZJ8xHcZEVs1IJ16MPfvcFNRcRN9awXLRVZ5UVwQPp9ceUt58RZVpZQTFiBGPALq5sx4D9zexF0sT+Xtvn40N80x2xFuXUF4RaW01bCrcR63KBiSPK4DKY7aXj9eLtI46Cp2SKdoLVAohgKhTMX410PzZyoZqxj5+3QxeLJgl9laFkqNbFA88nzgHmbZhwF4JwbStc8ibt7z25QrLJ60dz4Hv/4U7kxfzQYNgIE/SWqFTmUAGZejEnAvOu88uiT3YX/8sa7sYd1kUJJXUVW3S4D4LnfA4yp64n3Nz07h72o2ZBBF5oB24jDz9bOV2gzD9ru9KuB6L6Z8wzQcdpm9oJkraNI8Y4ksF4DEZClwCm6Y8p8dr+7IrFc5IVTvhzzvFke+6J8iT7fZ1O9z3AvSWn473Vutmg9wxWzIyrHAoIRO5Mhle+bKo1oLu51KWK+Z/upvwWCjUvx9roOxAP6OstSjr9XNs9LJI0Uu8DkHNyJ3XcAe+zZ0tmhi7sOUH/c3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 2:46=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
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
>
> Fix this by resetting the walk in each loop. This incurs a performance
> penalty, but given that only the RCU lock is held here, it can't be
> avoided.
>
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: squashed 2 commits, fixed up comment in code, and commit message ]
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

