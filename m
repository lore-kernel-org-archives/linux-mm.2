Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35785C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 12:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D64886B007B; Thu, 23 Jul 2026 08:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15516B0088; Thu, 23 Jul 2026 08:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C1B6B008A; Thu, 23 Jul 2026 08:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 985FA6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:37:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 032A4404A8
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:37:27 +0000 (UTC)
X-FDA: 85019992176.09.E1D4222
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9D05410000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:37:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Y+CpZNsJ;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784810246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3UKcAvC4cdqD6Ve05WpKpxH1iBS6zCA9CHEPJKcFSk=;
	b=ydbZsYyU5/VqPkb3l3Gpw2B/xAJJ8yLCMk7F5CRy/WFcXwn4M0pAGgYP9XjRhhP+hS71y0
	HXwPtyd4nwv9neQs47L+hBA3pflwZiWrbOS7AFaW1ZPoMaoJEaM5h4h/ogUJmNl/8z/N5F
	t8PKFGczL83PKE7/K/sVV5qe1tzWKXE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784810246;
	b=f7I6FDImaZi4m7j73Gluyi4iE3ubB//6u4NKMl0aYJTahzBv4NuRFpJNGGV4eiycpprfpP
	/Q/dJpC5h89rn2lkbozvDXg3EGz/aSGWn1PMPP6TWayA17NTwkJEkSg7815qIfLyEyX6Wg
	TEQfNXnDbS47S6pD4pGR0E+UyFq1hZQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Y+CpZNsJ;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+3UKcAvC4cdqD6Ve05WpKpxH1iBS6zCA9CHEPJKcFSk=; b=Y+CpZNsJZHsnt/KMCgiVInCek2
	Yq65XH+peUgp84wQqDIlJZ4TPQHVpNtqvX1haRdokLkB+97OTQyYHKMb6wF7iRPt+uWqNtOCU8pbQ
	HieFMqFvlAzzO2kd1crbVJx4dyKjgX2P/8rOZNwauVjcgXF8M3XtSPbkqjWFmmqDLOJlNuQ7mDWO3
	7AU9O26L/SW273UiUeOvxjFhYeHpQMOjMQSQn8YDfWxEDsGNWcDOMYULJ5C2pbcOzgTLsoCTD5Dae
	3ihvRpYwTM/kWyt9kKQbyJ1qh4D+wx0706RQj2icepwmgh4U7L1FhQl0XDvOKgQRiebopFbcqCqrt
	kfk9uvBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmsfz-00000000WFK-1HwQ;
	Thu, 23 Jul 2026 12:37:23 +0000
Date: Thu, 23 Jul 2026 13:37:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	linux-btrfs@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Help needed to address the dirty folio without fs notification
 delimma (Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty
 folios without fs knowing)
Message-ID: <amILA5-iY_er7ESL@casper.infradead.org>
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
 <9b1d42c4-2c3f-410e-aceb-92400b8bc24f@linux.ibm.com>
 <f49478be-70fc-4cd6-a640-fb008c21c092@suse.com>
 <4beadb76-8500-452c-b84e-206c50456b8a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4beadb76-8500-452c-b84e-206c50456b8a@suse.com>
X-Stat-Signature: qs6x4wh64w4fogro591b78brweiwn5or
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9D05410000C
X-HE-Tag: 1784810245-61907
X-HE-Meta: U2FsdGVkX18JcEvT9HJ23AhogDaRKbEs6cRTlMx66JJhnlE/oQmFrXeXBHTuMDs/aL65vdOtroGEJQKyGS59QKC8kbhagA1s76tXheG07rkKqmn7WnGL8wtm9OS5Rc2Xewh18pdBkfBMd3ce9qpbhzzlr6pVfJJAvYKZaOJ3hnAo86bcR93GRo0tGeY3wL6eng2fC3smKWKbgkiSqLy6nVWVlRj4/wkTILEc9TA/A4tOOqMi+KSNzu2A5K6CeyFwF/ZlZYHP9fQLlyXFOkudOgjLSqgpflDcLCC279JtQn0PwPFm6//e99rR3SVuZtIc+RF6Ba5Vf8s5M2KCSV13niysQeVoGM1VhZkAah+faPJPgWWuv1Rywnn9HntTblRhqONo1EBqPjGtJWo6vzW+2ORBFC85rsUcanthsT0ckueWH2ePyRlbjGnEF0fHzroXFaY/gtGbOYRKqtFMN8qvXIbIZlKO1GfPnIk2aTAF0CTaRJ53WAGcjopKfMMLgc/fZ5dfzwPPOROy+0emouR9m7dUfBb6xFkMmdAALL+cGNW+ZzDliY8Il1zPMNPuM2EzL3X8azzS0CN/rtsmbcgjlOnlkdS176b0trV1s2Iub+m5/5NkBoryAkRAiToxAy9w7MaoHlWoEZZf+5Nrq9Vv28f/95qLJInVErgy5YEAm819snq3FgM/1kVns1d9UIR2u6NzVgADMg2aKvsWQNfmcKxF/fVMPy9Zf43LZzRcEX7Yv+FBilCBDFh5krVio7NhPMYI3LoocGAheRmaN+0CipdTP+gCutUi1igqW9YuDmAieFdaf0CsShSs9At6euivdnN4PubnURdMO7IIYeS/um9krcrmi7PGVJWGjTlDPOzFmH+76RAdnSDDn4S8urcKkASzRv3VY5+VFZbNCGUmX9bMXk5SfyPAiRr44KLAJ3+hWZ/qaCfpsvnGZkYJNAdIxpeUjowuTWlr7FThhlW
 ZK1FAcTS
 kBk27ad5/yynF+vkPh7+Ma3U1drV3zV+8Hl1ZXwvMgC7O/O3jtBwpTvtxrs5wZjSgoN+NZPr5bne7NvBNF6h/jbRp7VIXNpnNpMlZ9Jl8gHyQo4R2oS3m8lRSl2XASJ+67xjywkh45RVFDVu04QgG9kmvvWRRJufQTAyvW5gTSAb/ugfv3EfBbbCnFUeLnbvjsTEIGVNVpzpOVNg2AJSp6ecPKS9F4kKWn9rlulE65Hlds8VyyzKN7vMsgWotrqA2sriaGQKfD4mYxOwqvJanMtfXngmQu6kSa1WbxuVVLg3yLhhSO0g47chL5cSyxVMEgoLtzP0i9vjkvErG/87iDcUypQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 07:15:40PM +0930, Qu Wenruo wrote:
> With that feature even if the folio is marked dirty without notifying the
> fs, we can detect and later re-dirty them and do the proper space
> reservation in a workqueue.

Oh good, you started another thread for the same problem.  I alreaday
told you what the problem is; you're not listening to the ->dirty_folio()
call; you're just passing it straight through to the VFS.

