Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371A1CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A3F6B00E8; Thu, 25 Jun 2026 03:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1B26B00EA; Thu, 25 Jun 2026 03:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0686B00EB; Thu, 25 Jun 2026 03:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD14A6B00E8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:39:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FE65A0592
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:39:50 +0000 (UTC)
X-FDA: 84917635740.25.C4D0A10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D673340005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:39:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jcRk2C68;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373188;
	b=OUizxO1ZFFr6WL6YTdgm8I/ggfrhT52HMjnKMql92f1Adb5q4JPDGBaZHnXr5pD3l2l1qS
	VJFHcQabjXk0Ca9J45x6jGlmvmI+IAGeavwIGBdl682LnzBUiv3qNNczCIB56nA3UBaKEn
	3awPOFG3uQtN8lWpGGDWoJzLEs2a0aE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rxNcPzydx5At+li1iBZyVzxXhFNYWSsj+zX3GmZWzPU=;
	b=glE6/+rBbCKLCkH+xQgt8s0XC0UfHsca2UR7PV9fXQeD/nL7Y54MfSRQSjTFhgG67MvJKC
	V83sEoF076iEYFyxwOVzz3WM8cTkoWJLJlnYK++3gMtpoJNLdNdfRb4pafnmeNFg24qNb8
	VN3ezky9hjX+OtKtkpACfnaugV5NIL4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jcRk2C68;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 758226021C;
	Thu, 25 Jun 2026 07:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDA01F000E9;
	Thu, 25 Jun 2026 07:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373188;
	bh=rxNcPzydx5At+li1iBZyVzxXhFNYWSsj+zX3GmZWzPU=;
	h=From:To:Cc:Subject:Date;
	b=jcRk2C684uW8k1B2fwqbrXiVs1Rq7luPZO+ahwJDKfeU6zy27Pg9gwlfd7AvyXj52
	 lhGgscGA4DhGwcuBkr+02xqa2Gq0kBtYSvL7zBxMBDBFiqUsz6FfdI/LT2Xk3y2qmW
	 lnI3xtXjvxyzgu9sz01GTrN4YWk2cF9Fost8pWHEjJEie+yoStCbD99ylODKLKHSUM
	 MhvhVKFEH6+ECn0CuHn0Zq5a7bm31hK69/wdDVk3ubqr6WDzCSie/U3dvbeiX4P5pf
	 2SVpUB9y9lpBkycH5Ol2VAWeb5ssrdud7RGIqRiboUzZILjtcjR7zHAN6COpxjuAPA
	 9aMIOmL+j5tIg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm/mm_init: don't overlap zones with kernelcore=mirror
Date: Thu, 25 Jun 2026 10:39:38 +0300
Message-ID: <20260625073941.145014-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D673340005
X-Rspam-User: 
X-Stat-Signature: du1j8r6ufyo5u1bc1crs8kksdu97fio9
X-HE-Tag: 1782373188-3104
X-HE-Meta: U2FsdGVkX18tVAYunaUqn+S6LHPmQ22o+9az5IpOQTIrR1lMUnVZNul3F+FBZZXSEzyJNU4wRXsmxbHHkTl2EPoq0cZnPrN0/iJpHphZjWtkzGR7XH8ew9GL6vEPqk9GPpq8EbJyIBhT0gWoUVy9rKjTS658BRGrFeTaR7XEFvvkuX9R22Q6FStAshlWsysxQM0fdYE88XsBuWaZ13/u7q5JssD+wAginahYg1lUYNWWpHOeonLXJTZniYiPQIWRPwUf/i0Kj0gejoHJDIv62oTGzL4snrkgix8X9gjksEgm2l6SX321FltjQCPqUXbCmrYxU86Btsb4M/7SCNthoYAvEzrcqxPll8XgGprR/q5rGTbgiHoK9tudJPwND00/5R+7RO2ZnVCe3Ej80R6sO64lVjqbRrie0pR07AVu/noIsL4/bsT/ZMjFOUv9TDWZ6vxc/W/OFnYH8wYV9aiwbKYlmGrJF/DtAnJw7A+R90ofOC/JvMF2I2oMxYhB+1Zlvz4etHYVmniIxPgZtpXlHa1xPc1+BN+0jK7+dAxTGXuwgeo9/qvTFsbW7P7+XTn4w6cdki5DjyHKEZTQvBxITs5O8JRP8oetcHabFnFPTMOy26ZqSpqNPhpPA5oCB0+1Y/2NJ6NKRbVod6XqBEPR20D2DqiCFLD1m5+FZ/oFCRW4w8dAzioCMGRdks4aEKma7AjbM9sfn/5fg3kbT3UONDZqD/CgnrRi8bEFZMcwT/nPhUo0ymIzPFGogeAnAVhvIQP9b6GXfUAe6qJmQ44nx7kkGEu51HzQb/qU6Vf7Tuat0rWLeEA7HGOw1g9SYLD4D4/cEOfvufSlIJtWtTxe1DzcpL547mMQb6MS65U9QCMYB7h352nyJB+O9aTotVX9ZZRFWDJrWyVX9KoD+8vOEdMdPCdq4ABpag5p5w8f8GRTuitIHyI6B1ks8tzk0yG1QAiEI53BKKoDTohDaT/
 IKIPOTQH
 YXFDRb0hJkgkq1sjVu4F2XpFzyScW7m7J/qGxsTA4iCfiUElP6EWyFvvez+hF+vo/yMySImljyIhJrW0afMClHvQAdWv5sHbt6Ry9aaWcGVedca0iahqcRRqllzt69+hOHGTGyTFRCPQVkiKI6S73NBO6XkmSWj9wMlrsUvBccYHAa80Onbweum1NTVxzgbdm7zjpQuikatjUonaWIjT7aoJL11XUcK+jT9MBEzCp5QEHbhmcmbN/QydviTCxV+KYKejhokOZVFoFC2GDxNnp3FUOxUVDHoizEuRxFkYKEqqDx3S4iNGFEDnZNNikvsTHAjHZSoHeVYscHG6+lJWItg9sutbGkxlVJGB+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches make the behaviour of kernelcore= parameter uniform and
treat mirror just as another way to size the zones and cleanup a weird
part of the memory map initialization.
   
Mike Rapoport (Microsoft) (2):
  mm/mm_init: don't overlap NORMAL and MOVABLE zones with kernelcore=mirror
  mm/mm_init: drop overlap_memmap_init()

 mm/mm_init.c | 60 +++-------------------------------------------------
 1 file changed, 3 insertions(+), 57 deletions(-)


base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
-- 
2.53.0


