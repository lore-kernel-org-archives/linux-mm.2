Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E9D10FCAC0
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADCDC6B0005; Wed,  1 Apr 2026 14:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DBB6B0088; Wed,  1 Apr 2026 14:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C586B0089; Wed,  1 Apr 2026 14:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89FDE6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:35:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 231A81A01D1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:35:03 +0000 (UTC)
X-FDA: 84610838886.29.54F5360
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 27DA9120007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:35:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AoLHSZHV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of devnexen@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775068501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlVOQUaZnOTPbWGSZaBZOuw1PRPEgQqbRv7AC0DsU4M=;
	b=gNrrXz+1kEkjcfNKecRLMhuKR4WlxxFc/zOibmxErg5M0rwH6oDekwtIUvnpXTiqZ2GTOD
	/+ct50+wJH1wGxTb3FsPWXOlwkedHtUWI00GQv5DHTvxvbIsiea0ZeyevY9QkqonVHMws6
	+AKsrN+VqVNWPpBr4Gxg0GckAsPwDPg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775068501; a=rsa-sha256;
	cv=pass;
	b=MCfrsuKitte1BUCi7r3kJf6QvT1zVe1FEg/n7dnghng6yxuPjlJ8T0IsF3VwHXI7YnjxnD
	LzdlgTNGoeqvXxZzhBdEAk8gg22MsIJtephDdi13VXc1SbNzMy5TDWHOIuePm7qCDDdW/H
	TLeI0Y+Xza+J7atW5vYOIgJjDYnnS7M=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AoLHSZHV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of devnexen@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d9b1c57a4cso37471a34.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 11:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775068500; cv=none;
        d=google.com; s=arc-20240605;
        b=OsWoGpUFuE5YeYflSiKpZFybNy6o1TEWggi7DDEpMgel5L183WNfDr4UkgBwdJleYn
         yxcYVGDMT4dTLlnmnMb2tizLDwf5lhEq1pbcX+L+7x1AwT2s6s7nKvbEXi0FaakFqeBU
         7/HKMobHGBItHBvzHrztD0ScqqGEBv/z2tHqr1oSoXsT6hCSW9ol8omg4tAeFp8mEakF
         JANWh324xSnsXxKBVm5mra33MNGdbq0aAwhQPdf1gSN4CIuUC2IMGV1u3jiFS9ZKidpY
         sjHCNPohX/EHm4fe87G9ORY/vFC57riIeJdwtzunjE/wvCfBHrHaHSVY9zJQwHNt3Ldr
         FrcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mlVOQUaZnOTPbWGSZaBZOuw1PRPEgQqbRv7AC0DsU4M=;
        fh=z45P8f7PU2BcJKBF8IkVij+XZj4dTiLbGaGtAfzUgXc=;
        b=Vicg9p7fg15Sy1ICWWj10NGgt0rtjWerUN+MuQMflLW/4GO8uzMSz+PM8ESXCbllks
         gjiq97RUWw4uWP0ktuC/A+BnKGwf0tyymBhSATZ/+bCoM8YGNYWbF73xb+9RWrK0TJwF
         nNU9V+ThSZBRmabfKb4Caz3SV57TB/9Vfv6yRkpDTiw1XIsoCFTjjkJws5uLvLkCWBsX
         ScQ+JnNAUGn0dEQ4NFZObCoGnox7VAjL/OmdqtRoIJqyUFl3EBPMxUWlr4gN+CcvRdS4
         drI5suR6+ardl3qSQBXtoGeLQ1y1t1Dgyur9Wbc/pbpOOOUiEDzxTHKYuEoocuwUTMp7
         Mcpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775068500; x=1775673300; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mlVOQUaZnOTPbWGSZaBZOuw1PRPEgQqbRv7AC0DsU4M=;
        b=AoLHSZHVVrRUHtdpfLiYvwG94y1QQU/h4bKblwPvKW8KtDo2gUQHkWuN5BBV7zn3h2
         59yzX8MAkzVeid4UJnsoT8eoqBHt4pmKNATe3KqxSiGaplOmBjn5gq2V4WB6wIVrH293
         jYKGwMxH6V62QBG2vTO3bwn8eGFVFyGrHLMv7p85qi4hph6q8+Q9RXRKhsInSeZMEVIi
         n/lvMYz6uMUwXeRl7QG01kTTwfp3SSLN4TyVv6OT9gkYmZjZnitgtCnVBAk373g6SS3w
         0YKktbsVjpEK0iuEUl2jX0iAss+WuuU9Pt/fyHdbKvpeaBJe7rub01SqNvCtF8F8Ctdn
         F+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775068500; x=1775673300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mlVOQUaZnOTPbWGSZaBZOuw1PRPEgQqbRv7AC0DsU4M=;
        b=YmTgsJDOAWdDgiCCvivV3emixsroBUt6Y8b0CDGaEQbFWwXoyd3Sjwogc0ucWa0Qwo
         xu80qBT9T084kPw5at8oyYzBTeMueKd75qfkap0SYnUP5e9xkr+Y2f52mHyJp4L4Q4Md
         j79uYpUAsuUQqzufFjbqAXa6exGcrnyr2se799zzdTGXakx1iK//3s6LdUb7uRTRU8YO
         w5oglFQQ+8taFVw8Oo9X8f0lmDqz6aSpPcNlXlaRCb+GUCASWNn9jAawkRByNDGA8+o5
         o3rvBDGE8HQBcwW0881Fm72EgzytP2A736fRdpcs++0H1uj+0GHiOlpon3PL9ITyOu4j
         el5w==
X-Forwarded-Encrypted: i=1; AJvYcCWDiVMgNHU/f07HRVyEtkWMd9jjCHHu2DsnTutx/uilMkd//x718v6oNdGvMxj7+6AuknZ6PPcCWQ==@kvack.org
X-Gm-Message-State: AOJu0YzotWPOT8TSZCV1sf0Hfcw5IhJ0fMzorcZ2CZMEyY+KPHkgtapl
	LMFha+Fjzn/fDqkYK+elErWDUnM1SoyPSvBySe8ZmsrXC4zaO1ouCgH9hguLOBvTPyrDqfr3koM
	zRbF4L96ATcg8xp7Gw0HhAwi55G4DYuw=
X-Gm-Gg: ATEYQzyMrSGwS6E4eWebTqf83GA3XCZLS6N2CeNMlpQrKxMDn88tYePlpuhu1K7cjPb
	/lPCagfwtcR59LBMhmhqnezR+wq9wvfP5EF3FjFwm2pP5cC8Gii9u7FsojSKKKlSYmsIRQIf1qJ
	0438sJ1dOHq68e67umiNOzQeN736G8sJ/xLKcHn4s6PGv2VwiHEP89rqvuCHGAPp6yNyh7yxf1K
	PT0Un9q07gQjj3y1As5I8JKQMyHy5xLarqOGktnaMDjosgsQ7wMhv6j7ySAYyY0cdSfOThV6wAj
	LbD2HiacL9QFXIoxlPE9wSplCmix6dUFJUecrA==
X-Received: by 2002:a05:6820:4b8e:b0:67e:3538:d0fe with SMTP id
 006d021491bc7-67fabbf146amr2398728eaf.11.1775068499962; Wed, 01 Apr 2026
 11:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260331134158.622084-1-devnexen@gmail.com> <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org> <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac04ZeFdz7yvByRp@x1.local>
In-Reply-To: <ac04ZeFdz7yvByRp@x1.local>
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 1 Apr 2026 19:34:47 +0100
X-Gm-Features: AQROBzAkc0QsdQT4iEXFNdWP26oEjeca4IQs1_q2KXJRoaenjLcXsIV2sEpz9vQ
Message-ID: <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
To: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 27DA9120007
X-Stat-Signature: 6bkcspjau4uw566s4ptppskjo5jddbk9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775068500-572956
X-HE-Meta: U2FsdGVkX1+l6MZUUOsctHGuXPkBWRAVExfyd0X6gMYy4btlPn5JkJvmof9spOjrTvlsn6EDL2DSByLSt/+dWMsQy3Dh0m463fKxuF/uwhC81w+cnpdEb4Y1hUtmL2c57rEYcY4iCjNJp67+Cx7a4w+bx6CDrdHFG15by8u02wL+3Zk/lkk1cZNpQ2j7gcz7iI5RCE8HB4E5cbbhmFAgvjAnKSjtQ8h05xFBmjOU32uMzh5/JIxFqMdCxqm5NAoGvS8wWal7Nfq3wHRJ11v9f0mAlakBjhNlpmTUwrn23LSsIF5uhz9cMOkFREmR5y60KPqDhWtYvzwLT4NjPwckPjiB60H+aBhFSpcqktT7W3LuZNrCAV30g18KsFPqMTEDjRLyqemfUf+zLTtTJTBHjX/7P8j7jAhetLMDZ/E1TkntNENdf7i/jwVhPzNh3OT0iHE9us2qDuB/E2nqPWJ+NDnOQ95LmefU2+Ir9/2VjAg5vt0WN14tOwBKG5LcSqTBfU0rxIMCX2QOPbFMxCY1E1ocVc/m+5LIWtM8XlGJ+VlpQzE1aNuooIKUVDIMueQd15Yb2C0gar6U8w3EakB+sgSpwhoNd8BOwO1JTroq3K+fHg2HOm/A1ElD8DYhRUsmyWJGE1D9RoioHJXl37YT6Ack7sfnnh8vfo3pDRd8d5TzIzPfov8g3DsDt5TVD6F/hFNNqeSJzhzE3fwXFWrugH0rVYTQEMIH0fLL5Ls0wRO47pEuMupaSr09+PE+f1DkGoHakQgqovsxlobrntKmRu+Qlt6fQzRECY7jSueKVV6wAVKAFhqvkUGISES3Ht80EYV3GG57Mvxq99awRLp1Px5ry84PWtlQQSDc9Eq/K0OuM/c/EZMEq0qY7MPAxhGTml7wWiVfrvantBItO37sg+8KOVl1gp+zaV1RCN02VtX9m0ai0nMFywaEIbiMoCY1a4ITVheG3AbX/xbntJi
 ncbj4cxp
 2d9p0TkNdrzmw/kEyUBMvrWT7n6hbTzGiM1/CaBmz3hR2Ihy4p3wUAytJJ+eRpuSVXKZhcip4APz0gJ1Xp6lO8jKWDcWf9mrkHKV1XX7zAVjVUo6Z+UZXRlYF625+Z1DXxNhtQR2TF/bxbk6JA80dW/LSveNDZZSJVEwhta66azUBVnkiAS2mW1E4biEDoXvxH+/u+rc8LJ/3IzlogRRk+QOXykSC2j85TrLn2Q76R7WgK5KwKGTcuoiASxhUBbXyO9dVxxM1zW9RBtUsLjJARj9yHdf4VbzDGtwFFevknnVkI9x8tO27uq4LcP+PDtOTQpEKiS8AXIPLgg/lytphZL8aD4oAC70ZVVqp6RPYb1QGMlRr5Wq+ywI+NxzikmBJOJgnXw8GBMGUtn4OEMniTlzKpPLr0qQ1HLloATdnMCBi/HXuZ28IS4g+jUy9u6Cfza8y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

  On Tue, Apr 01, 2026 at 04:23:00PM +0300, Peter Xu wrote:
  > IMHO the flags is needed, consider a shared shmem vma remapped to a pri=
vate
  > shmem vma.  That needs to be covered in the fix.

  Right, I hadn't considered that case. Shared->private changes how
the
  folio gets handled even with the same backing file. I'll keep the
flags
  check.

  > Actually instead of reducing checks, maybe we also need to check
the offset
  > of the mapping too, that is: vma->vm_pgoff can't change otherwise it ma=
y
  > also affect how the back store would behave on this UFFDIO_COPY
request.
  >
  > For that, see the example of shmem_get_pgoff_policy() where it
seems we can
  > apply different policies to different ranges of the back store.

  Good point. If vm_pgoff changes, linear_page_index() derives a
  different page cache offset for the same virtual address, and
  shmem_get_pgoff_policy() could apply a different NUMA policy to that
  range. So the folio could end up at the wrong offset or with the wrong
  placement.

  I'll add vm_pgoff to the snapshot. So the full set of checks after
  re-acquiring locks would be: vm_file, vm_flags, and vm_pgoff =E2=80=94 en=
suring
  the folio was allocated for the right backing file, at the right
offset,
  with the right VMA type.

  Thanks

