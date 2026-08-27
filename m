Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD069C5DF97
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 01:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033316B008A; Wed, 26 Aug 2026 21:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26366B008C; Wed, 26 Aug 2026 21:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D906B0092; Wed, 26 Aug 2026 21:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFD0A6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:00:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 566898022E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:00:49 +0000 (UTC)
X-FDA: 85145244618.15.9982849
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 367A340003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:00:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=iT6QIgop;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf12.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787792447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=;
	b=TlDrmTz4Wg/bYLP0fNg3sJDucQxbZrmWnT10XUHjfVXE4w6rfRFC/i+nWdc9i7NythNV8d
	6oDAl8MTjECJhT71TarEw1vexPEY+YFZytbuvNRZVnFwLEQuTTblBtvm61NqBwI64uhERg
	FvEYVQDUh0nYMrOApkHEfxa63xFxTJw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787792447;
	b=0ssI53kbeQKG1VAjMHWtrG5tshquDanOHlWIIgCRTFluHM165E8MMR22EE5e/ldy+ru8iN
	UganXHhN8dqZSb0LR3VNeZfE+ieaL3eNtuDHNI67p3QxbKHaAbA6cZ7TJDZflDGoW5eh+N
	3f6lhKgFQJNicznfPK2GdEod9ctrHL8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=iT6QIgop;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf12.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1787792388; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=CBO3da8lJVg2B4cJHrUIFYyYxtxZUkd1VtjRKcZZeAba59FmtEtB34kNhYL845cMrkY9C786k5pvyg6X8Ka3+Iljy1iJjL506rCt6rOpizQRm/nBREw5E/cfY+FQsYbeaVzXLz60Sr8QB+vnZ34fE6jqOrvmy/mHD2J/jyNLJic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787792388; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=; 
	b=YZJ7E/HWryfyLI2gIgGjq/Ou17+oOhS0oihX1NJhbGVIKdn/MFaMztKIfdPw/lpG87Ln99tfomyOgGhE1Q5wFHflFWk8tYdR6HWY9NH1PDU6DZ6V1xt+0MymX3HgYYEmC6dwpM0PZ6mM/setECrHCtmirHuUEFHd9NYfZk8qPZE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787792388;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=;
	b=iT6QIgopJbHL0/Egv2fhTRLQq1DqymZj9fhg6DoKt4q/Xc05QYpFn8+wwa4QHc7z
	VmF5VNmT6yDICFCa3xJohEglBjblnHEeqtAUzzgIBh7H9cC14koHC3zSUUPfwEDVM6X
	b2k+09Hb5bUBMXda7EfiIeA1vx8VBfldQFtQ+TPo=
Received: by mx.zohomail.com with SMTPS id 1787792386008226.5796055590763;
	Wed, 26 Aug 2026 17:59:46 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v4 04/11] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260604-xarray-entry-send-v4-4-965f6028790e@kernel.org>
Date: Wed, 26 Aug 2026 21:59:25 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tamir Duberstein <tamird@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>,
 Daniel Gomez <da.gomez@kernel.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <CEF7AC1D-4899-4EF2-8034-DBEACBA909E1@collabora.com>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-4-965f6028790e@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 367A340003
X-Stat-Signature: cf11zgu95p6qp1xh1j1wa18cqxybmkas
X-Rspam-User: 
X-HE-Tag: 1787792446-784061
X-HE-Meta: U2FsdGVkX1/0K//KCQeI99xBYU4a7TeDknGlE/OSJ2w0puL+qrXRip2ad4KSZfKGqitUfRgaQ884Nt++iCND/jn97825qiwy5zOY7zPcZS6j1uvdcfBIQPq+yt4ChX0hWNvWM+vQHxczOrnn6oUshlZJJXM1JnDxFUOQgrL8YTiiKodtfwqCgsYvnq9s/PVUCDjVOPoiB5N4F3tOqlNH5OtEXjVR2qqtC4Em2ObvmaN/JK2oBP2dSMSe+8lvPkzvB3gOiRDcULkkPpco8tFT2ZnXB52+IDfzhdwkhr2L7QCu9t099iQ3HXzaHnFzeLDK/OFgQAzeMBP1vhlxxDch1bDzKcZ24bTcqno3Zb4Y5LaOXGMYpnMutN4M2Xejz7d1Cvq0GNBUGiki4RIEeodj6w22bUQ3qAN5CScGf+dNCXbf/gBsCu9ecF4NGqikWuEC35XAglHpabDUqpv5u+VU0P7QJXSbnlWU329pC4fxIErrol5ypf/cP+Po+GNs75Y2iX3arh/PbWFmd3Dd/jbzMapNdERmQl865RiNXQq2Bycf05SL/DjAsQngxTszJWWlfS1UeKTGalVEjVENf+nbNN7NsRPnPMQwF1ifqfrk9DQYXNs60hsswsKAtPOqkzZZaMPF1CPvswiOgMnciniEG1NmuFvpL3UnMffLaO3qcoAZbQ7I0fXDmtw740NaFiqGb3YBzY3Ksyhac2g9141Uiko/dXtMrKD0NzT1k2r+grrSaRk1fxyoI+vwMc83KdoiQT02Eqo+MoelCd4PgQqqFu/2+NjHiUbGMPcofjXB7Fdthjr1D6XicsemWtSesDhgq2n8AsaV6maHsHl/j3SeXmrBzzB9E92z7E0Cs6nz2T1K1GZU0Wi9cFaGlpYcsfbz/gMui3msAZsw1LUFy8BI1m8mG+IkhgpuCDNf/ADfAtBtnhLiMrINfYWFSWPvvUbF5Y8uFU66WwBv0qJ0MPY
 JaO+dvgN
 A8YVg2GvbykVUZt/uAo2AO3XKGa3rseotz+mp6/VFpuF0iQn0f7iL+PgUNc8JlYseQCpwlArzknG+Ds48FMBsM3lDM5y1s3T6CnTbGZ0WAWkPb6S7Zbxg6WVF2piaf6IRt1uiXGPqnB1TuFlpj0ZWaMdwmjfF/5MU+UKlThqQP1Q8rqKA4WoLMBhkC0vhbtFBkW5bb3H6U5bTUEwVkwcy2p7/nPhNTugwY1T181kfpmR+THeX/9EYjkBlK7ThvuUcXY4a1KqZVHblWiqZ/GrzpGLdkx3cGGOYPa+zNi8rB8NdE3eQp203bX4PdXoE/D15I3w88SASPk7x9WnYJmbYIIwg9jozzWCjQKVJY+uzX4WNF1+gnTthExDhgLi+SFxgUCYHljk8RJMlZvfO0VTNc7ixGyhELQv7EL/f/WMzXi6Vtrfj5cUKcQtG58AFL/jJMTe0b0AwO4m0L+0JcgITi/+KY9SpYLe/Xi9htLcJTtofl3aRuc2utq6/s9bIeU1GZamD2x7AVmCBu1xs8wDTmOzTZ57v3bJJiBEuLOCT+YJltBcABlV1VeFQb+5IC0DJd1Du07EemJyqWFNJfSkGkh+BqCf/LKI7g9fagsqGZ8DLXC8l056O2xIMALSMyVgmZAWIaakcBTjjgHq8gqdfU1NtDT6R76tuylq5qJSrWEwS7sM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>

