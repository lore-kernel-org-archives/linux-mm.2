Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAD2C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C722F6B00E5; Mon, 31 Aug 2026 23:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23736B00E6; Mon, 31 Aug 2026 23:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38936B00E7; Mon, 31 Aug 2026 23:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 930996B00E5
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:42:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03F59402BA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:42:56 +0000 (UTC)
X-FDA: 85163797194.19.05C7E80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 698B920003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:42:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UJ8LqYiZ;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788234175;
	b=usro1Js5273I+ASFjc9YGCWIfMwwLO50kVBWAoaQWR0P3A+IRF6tKs/ERpYvgpZj2H5pXL
	GXhhgB0GPVttTva0hnOFnXBA/tvUlaNnfRIC1yMuHv6JsL5ODZ4nZvymPtvdlUZj9xIv1k
	+at8XxS2YBFkU16oW9ujN/60QoKQyf4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UJ8LqYiZ;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788234175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIdSMDhEc8u1zhHnOTeFtUdbowkBs12N1+BcyzKGtPE=;
	b=Z0vCDRd578UgQ6Fak8FlfP9ZJLl2iVCRpz4qCJmLIv72YHiCJ0/zwEwqt7adI5vVJPCGY9
	FYjGK35R+3bVTyxDsOfQufNDdO5S4spo6avtoX97cAXRct84K1nWe+nxjWnsnD4THSlFVs
	p9jsQ/4yswjmOCXdhA+faWsrqDDa4c4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 848374005D;
	Tue,  1 Sep 2026 03:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0261F000E9;
	Tue,  1 Sep 2026 03:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788234174;
	bh=nIdSMDhEc8u1zhHnOTeFtUdbowkBs12N1+BcyzKGtPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJ8LqYiZ+l53lNyjZDDE2sHSarZHw3U1OOGgvMOLqQBnXAkAca8noRuu4UIJxt5yW
	 EByJYTiH7D81WnjSvpGZn4S9cGfeq2Fz6sF6YRovvJMkyQWs35cs0r8U1q/XW2AQzD
	 R+Pz7GpDj2ms4soJ+ekx1BXZCVzv6Ae9iIudb8w/0GvNUpNbftc/Km7JJrFeSWt3E/
	 AVoJunxX8dsb8Ybjr+42RmjFHIG1dbJwk9ktI1nSMCIw+r89Z4SERI7JoIOciqR7VI
	 D2KWdCHWgOKguCthHHZ0Zxc6dmx+B0TE5cqS6xQyfvlKd7DCJav12M1DpkYnD5UByh
	 htYz4i58MWyVw==
From: SJ Park <sj@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] MAINTAINERS: add memory related docs in core-mm/ to MM - MISC section
Date: Mon, 31 Aug 2026 20:42:46 -0700
Message-ID: <20260901034247.92019-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831-docs-memalloc-guide-v1-2-547718c274c1@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 698B920003
X-Stat-Signature: irnrtzc8hafp5656kg9ng5aj8dpu6keg
X-Rspam-User: 
X-HE-Tag: 1788234175-536933
X-HE-Meta: U2FsdGVkX1+r6CKc6a+kE/qD8bgJtbkc5bd2C/uGHVZ8nF58JhROmq/bn3tQXCtaYQwjX1DrjnmIE4rtJtvaQWwMqWe1GfT5hzrLDzDB/fRQncFNIGnt2SpejyHfbXRev+4u0NBzVqwWbplSY05uQU5aQL3SXlCQme5gCcjPaq21GXDZ5CKuQkKgNMS4b5bMJkO7YHKDNVLjGxvjVlFRgF9CPx0DjEU13y1kDWuxsSmTfGAG74ySNbBJBH3fr2O6xyz87vX9G8iJZiJnXxgSy51h2eHzPZWVp8pVZz8/EshwBRhRCN1jWSSApNpQJ013JeU1vyumgZw89GHRWzwMfDtUs69F8mZdxrIY6STfSxHqGH8THCeBg0FhH5SKeEonufRSATpRjj2ye2ZzoZaJYwSK1THa1aUD3e1IqqIUXeafEprdDZ02y/ArBzHUAxFiCjfumYAwtACJMtlw4LtPjio/M7W6jWDPopw5xIdLiX3LMBPvoyXDsjUcBnCieGyPAk1QmocRKkN2XCYgeVUG6xtQkF6qanFOU8DTMsR4NV8MqHatf5ZudOYhhR50+erEzTcdW+O74qb1WCBACuRu1ejglFfKK+Z++X1kRuw0nyTk06gAWkdmSqqin4cpoIPSOJWkp9a966ETHjzmxzvcpr4D63Duv8mCPv36tk0XcicRgaGRDGalNiUB96LVbXM74nINrUEfLG/cFdhGQ+qAVxEWLXblj2OEjxuag7bYelvV7/1QvZRaWZQm10Odzvkigem0FzwtqUKDteAlnLaNJDT+wZPDVUr0ja/AG8tiH8u1BOUT6m9sM4nvJobH2n1wG5QZe83vuTaHYHiU7Brx9SoXwzCeyTFNjFbtn5aoVdQMciu6D9tszYA4IGGg78FyicHyI5MFukoxCvmAmXISvaiQLmPIpFnG9to2VMkUM84J1k8mar88HIe3hQFjUa5TFfUdt90Ortr2vR3gBSu
 uxEtF2f4
 85Ae9H3G574qx8KRSIS86xyffMEnfs+md2CchHxCQ8iJsRkkXELOkGMlk0rYaceHiZglCUECcbHpwnzxaaF+sjoU2v/+bS0dTfWUtwsxH/G74VVRoAFbw6N2u+rwqjWPUiCJJ8R/gaiPz23dp61yNymgwH1UDXs4sGGR1KV9Zmr/9ZXivg3B+A8aV1un71N5cWiMmEW9LeuTjwtyIVvz+9ox7o1zAJDFHS4t7LgxLnmDCBp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 18:13:02 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Previous efforts to make sure that mm files are properly listed in
> MAINTAINERS missed
> 
> Documentation/admin-guide/mm/
> Documentation/core-api/memory-allocation.rst
> 
> Add them to "MEMORY MANAGEMENT - MISC"

Makes sense to me.

> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

