Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5AD7606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 00:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IvIDpR4j
Received: by kanga.kvack.org (Postfix)
	id F202A6B03B9; Mon, 19 Oct 2026 20:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1366B03BA; Mon, 19 Oct 2026 20:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7A36B03BB; Mon, 19 Oct 2026 20:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBCEC6B03B9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:14:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AC431C4001
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:14:24 +0000 (UTC)
X-FDA: 85341082848.12.3D81DAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92DF1180002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:14:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvIDpR4j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792455262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qPYoL3A2hx9WJ4xEmqB6cVXrCCfT79632zdTBXvwkA=;
	b=Epch2rzeTUm9Y+yRUiP5NwDpgR7BOZn2yi3JHewIdSbS+LHcOVY+G73rDjyFe+72rNv4St
	C/Y/OwLVLnZDImeB+QDa09i8pnoh6eYhUqIG5THwnNQCLHveJJlWItZO9UjDRUOjs/zpd/
	ezdT51ditV5s0g3y1vXdlE7anN2w7hA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvIDpR4j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792455262;
	b=tyhHx+cmkLRwoc9S4lDEvpWwQvLva9sttseT2nocpuv0aWNHLVElJDwFEQctpCHnwfoMVR
	u3OOJpxA2kY5JycMcsyKjlNksqiirNEWyhdlKTyz12dnPKocdzIAYrzL31m7LUwcF+ngwv
	pvWH7nD7LfUcXFeCvmaFClbD/Z3Fx7Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63855601F6;
	Tue, 20 Oct 2026 00:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65581F000C4;
	Tue, 20 Oct 2026 00:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792455261;
	bh=5qPYoL3A2hx9WJ4xEmqB6cVXrCCfT79632zdTBXvwkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvIDpR4j++b2huvqPh6nDbkh9mc0rSHkK30AvHqO9crUdbXCTz0UkZKJp1krq1Md+
	 qB6JudbBOlS3gi/kmOEFBhrE9/rxUZ4A+cQ2sqysGwDdb7cA0AjY3MfkZrKb+RXA/C
	 1nfA6AO8xjJyG9Bb7wUreXHXVa2AKdgVer8Nxw6nm9ZurQ+SlSt9v6mJafk1oQ5psz
	 fVno1QV7jr5SyQkRgFs88l1+iFvXcFh3SJwJFI4TS4XsUgIerH1YFmwfexeidE0Fmi
	 jROTfX0+005Am1zaRUtQk5QfISd/zVq99okXKT/+qGSMplsGtl2diLdK5s22VS8Byt
	 UyxrNH80jbfDQ==
From: SJ Park <sj@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY MAP
Date: Mon, 19 Oct 2026 17:14:13 -0700
Message-ID: <20261020001413.102313-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019-memmap-maint-v1-1-80850871d0cc@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92DF1180002
X-Rspam-User: 
X-Stat-Signature: ujt8ng1hi96wm9f8nifzzjnjdgsxmq9h
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792455262-723043
X-HE-Meta: U2FsdGVkX19h/LVVzP6RhJJxFtvLBB4I7qKCWXF8PW5P5mITkbs9wbyGOXlgbPcqIp59+chZqmKbNpjf5iojDbi9KR9ByV4usfGgBxjvJWCn2NFntVGwVYUC48bhz2c59sVyGK1QQKq+IYbvQEMmDxg0Ea1jDbfPiOTlIXusQsCorpdeThrNqij5U4H49/2JqwM0KO0PjK6cqwhSWvdi6KLwTSok47UrNqhkCsSWiy2xy1JcUCkPX/mybYlhh8WKP4NnN+VyspZMdAJXV5r8yjBU+2k7cY6p1xsmO0H08JRG3lctyzZNEoNMiLVJErnPCssgupuD6uyJnQQgm+nVpVVQxoKvPC2pSUxVppS0YAgzpusgZRVaYvSaoD9ZMrgVugVYITWugu3CJT5maQaaBNW/BynDoca9j6uAADW4TCifoZTEFwtt+sT5zf9eUwa6ufgEwJxR5bHxml26I+QDFvABB9GL3z52UpT/l6Rm2zy3gx/noTj6yaI8l/+EW6FPTtH9ch5+CKqbyW4jGidxgjLu09YcOAiA9Nkom5UWowr9jipFSz3FfbUj85G6oYzZpG3yx7iNaCD45CiHx8xzUPrv+nc1Awsooj4JKod9BFEcrIpvu04uBk4HMMOATLflOU/TZbOeUw7ie2VVUk3VTXNBm0+go+lDnNs4dLodhNUEGoydyp8MYGkj1GTKr08uSdrzNArGs8pZyQQBzcSruV/QXEZ+9CbVgDebd0bwTxFlTzmaLkyWIFTFJLxT+hpp96dZz8MYKOmB7Jpj4WjiL3CI3MYy2Tc6zTvwzvp4tMn22wOHzJN/EptwItlPsY0SFzZOLIHKhJg20e4b+eeofBtc8/juomMKuVMEjNWdtMoSLpT/PD0GdDc1tByaGsx1/TCSRnyqTBPTv6zHy63JMFUaG3maHYraPJN3dRZRIPs3Tb38fV5P/kUi1Yr8J/i0RK6beF5gH+zgJM9sWUe
 h9TqYobZ
 yQ6LZ88B6pqwrf7LoSPaKntKV/C3ABMCptmUbo6rUTyOyAOsUu6ekQ4gXXcqPcLHm+Lci0Mf5W1WI3o8T2gKxIO3k58IqGLLo8w0xMKPm35SisVAP+xqoSDuir1ZW2d+lkhtzn4l/pD7m1D30DU6KWdr7jntzt2VdELrA5eYOmMK6Sg4nE5zO4w5yJuHjf74BNY9j/6HE8ecu8jFOZuJaa5ZDQTZNvUxlUyaImQi2fsU2ApI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 14:34:26 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Split out files related to SPARSE and SPARSE_VMEMMAP management from
> MEMORY MANAGEMENT - CORE into a dedicated entry.
> 
> Also include architecture specific sparsemem.h headers, pfn_to_page() and
> page_to_pfn() conversions and Documentation/mm/memory-model.rst.
> 
> Muchun, who did a lot of work cleaning up SPARSE_VMEMMAP and extending
> vmemmap optimization, volunteered to help with the maintenance.

Thank you for stepping and keeping up, Muchun, David and Mike!

> 
> David and I will continue to look after that part of the mm subsystem.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

