Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC47606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XeaOvVzd
Received: by kanga.kvack.org (Postfix)
	id 29DC16B0785; Tue, 24 Nov 2026 10:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E816B0787; Tue, 24 Nov 2026 10:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF8A6B0788; Tue, 24 Nov 2026 10:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF0016B0785
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF0CB1A0BC7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:06 +0000 (UTC)
X-FDA: 85470416052.05.2F992F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4A719180009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XeaOvVzd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534625;
	b=hfFuxbPmXF2UinlzFKxfzzQpBE6YgBUzDQLMZc/FbBMTJtjYs+TMvHbs9469S/DlHOOZ4+
	FK7qk/oENdlvIMKFN2SA7KpEkZkO9WuzAbIDSYozTprTvHR9XU8N3OatD9S+eu3Kcj+l+l
	xtRXiH469zvgHVLUNarcxP7i0Md6EA4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIrOYaN831vgERKHpIKG7bVf0L3TmYP5F9joS+wiBOM=;
	b=3eykdU2AElHmgSzPjehPVs/olP9SNTMnRqH+0xhiQSQ8SlChEz2L2/IEtpjgd1+vPyqA8r
	azo/Mkm2ZmGP4H2gq2de6nkQnpE/v+FA4ohf7jpp2i2OFUYGpk8dkVLi1xiMMtYRPK0gCL
	K60YldYIAckkWeq3BHudlsn8tXOvXsE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XeaOvVzd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9432D42479;
	Tue, 24 Nov 2026 15:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076A91F000D4;
	Tue, 24 Nov 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534624;
	bh=UIrOYaN831vgERKHpIKG7bVf0L3TmYP5F9joS+wiBOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeaOvVzdF59h3OQyemoFqvqD/BvYlAIHW9aEGxsJ6iCiMxky4JlfhLAVH/67MMp9z
	 nMw3WDvm9RGYkJ+0ViLSZ9PDsnzPgNs83NzR2gjxlvAh29GwSvf+MuhZuUZucspHIt
	 xhNGKYWBroM/Y/8C7cLGNycidsBMQqNinOowUwdGQY5lTOaPjWVFFsN0Ur5hiYpadt
	 4MHRydvjU/ubN8ychIoWCyalRzUXtbfaiYiXmOP4bp96bOTEIWFAp+gxL3BSx/bBgZ
	 /ynMlHH5PziG2i7DLjl+Sr/TEPUbPXf/+FvZ9zKF4kSy/bZQ1cb9Ejpbml92kmaEqy
	 DMA3oZLXyE90w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 25/27] Docs/mm/damon/design: update for user report support
Date: Tue, 24 Nov 2026 07:36:31 -0800
Message-ID: <20261124153636.91854-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A719180009
X-Stat-Signature: f5o5wf9sz9cttzpzbwsbwqj6qpzrh6rg
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795534625-912890
X-HE-Meta: U2FsdGVkX1/m+9o8vIriHryNUR97MWASzJ1BWLEAV5cQxH9dmQltfCnNLyVIwNHDS7rf4VDfSZbXMHCAslGeRxIpR+AbJL6LFY6S0rbx4XoYyWTYFDCyWpDOwb2I3liQdvCYVhrF1h0zrkqWHbvpTEVoLegbZ/nmAEon3Ccq1Qdz0OML/XuynOUheyvfTKiCTvtqJjhmRnMiJUS1cxE+EVa9HkstCSF+fozeM2b/ijXulkKTKWmjJCRETIdq4GkOFTtJghLNi5PMJYplcZViV/doGgrQ8zvNRbxjSnxzPXSkOZweTWNtgRdJiWjetLYls/m18S09C7LBdk/S7lXlE09yJK1kgIbFFlx7P/4+LLPFuzii/tLrf9henENsaFR68gPp/LITFg2LJGqC/ETS9Ww4DoXjXUslkfOuZse4ZAsQFBu4dttkORRhi6FTHENkjWAti+KVj1J3NjBfvWnuenB0goi6MxSfWKKNk3kDTR4yYYLRUYlw0a2G89EBK06XEYU6Fly5RU1XVB9u5AKlBMQDZ2QQcQzOozj/0yNUPdkkkxR7GNNQvYgTLq/PkwaHHPwytmqwQ+tE2JSOuia7NLgy1ooq+ckLBUYbasoRPtqhD3xntPfVYo22hKttd+wx+1kEwwRMUx8AQcu4/Mm0TU9VlwTniSKePL2I8Sf191L41dzj9dcm0XU34zJPFprH+yTR36X685LllBwLwEy9wclq4LSp7YEYAc501sOmFaSjWNiCulEtdvA4xFrKrIQ6wKgf+jctPz2Pc24C1i1kVu17O6b6kf6DVf19IjKwP8rR3JIVafY5sXDBd1EyaoslCoUGf06tVrCsTVg/elzpU1lxgcRHYf3zKTbjpr5fGZTRuFT+qGXfAXpmHCV+ItLqIz4Dbu8+OXX4hCSZKgj7qqtObe4XpL/ozF72x+V+WSI/Df80lUaU/MZ+pe7eQkQAUfbTSLEFDLfrMwlqE4n
 lKrjp6OQ
 PGr8kijlvPqAXkuMIbGifbRUgrXMOqDzecw/jL6c4syTf44Uruwg/oPK9N8VmwXYMCgrnFSA1zdeyoInMdN5zJ3LcvDk46q2SDDXSeOXXIQAo/i70T05O4WwnR78VRnkg//Dq6WinK5+qcvV+e2kFde8p341YCQPYB9KK7ec/qqwEwFBiBg2i2sgh5zXQfe2QP77I7TVdTw2fZRKlY182CQGyVlJJHTuPmHnBdEGJ/CCpD1ksi2K54t0T5p7zjNhsi5bm8TzTmdSFbO8aCTfFMi/GHUfPXbYDBOGRp69KKV6U0pbMYChXSSF3Op4nzlwdbwWhH51Cw7+Q+/itJHkIBmNzj/qigEdOhvgu9vuZ8tHfxufqsQzT5dpUDbcZx9+meMcvwdlKmrUfNcXNhKTXan0dKEY/ueYEAuy6gUDTbig8BfJ0PiVzeV5Dq+RjMYur365M86GIsyIa0H/0lTisBBsF2KtM1y54SrxF9Qn8KslZQtmaPIDmiTz37PN/HNETbqG8j1tC++bWkSJRNAxYkfue57JQSA55JpEyektC/a4hnUED9/72Kpx9wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly aded user_report type data
attribute reports.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 7ead5716d0c30..70baeef7ec916 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -382,12 +382,25 @@ can generate and submit reports of the given type.  The generations and
 submissions could be done automatically by the kernel or manually by the user,
 depending on the type of the report.
 
-For now, no report type is supported.
+Below report types are supported.
+
+- ``user_report``: User-provided report.  To use this, the user should set the
+  address range of the memory to report for.  This type of report is not
+  automatically generated and submitted to DAMON.  The user should manually
+  generate and submit each report using the interface.
 
 The data attribute probe supports the reports.  The probes can be configured to
 hit for a given memory region if a specific type of valid reports that are
 associated with the probing memory exist in the reports queue.
 
+For example, users can run DAMON in the classical page table accessed bits
+based access monitoring.  In addition to that, users could find hot data that
+might not be able to found by DAMON.  DAMON might not able to find that due to
+limitations in page table accessed bits or its overhead control mechanism.
+Users may be able to find that using their access to workload source code,
+experiment results or other tools.  Users can complement monitoring results by
+feeding the information as user reports.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

