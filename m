Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE256FF8861
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 00:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7166B0088; Sat, 25 Apr 2026 20:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E7B6B008A; Sat, 25 Apr 2026 20:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE24A6B008C; Sat, 25 Apr 2026 20:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD496B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:46:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 639F3140437
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 00:46:58 +0000 (UTC)
X-FDA: 84698867316.04.127A719
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id B03094000E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 00:46:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rlRFL6HT;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777164417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Zy2DJrRJGdFUsSTr714o7ATNF+h3r8jGyotdyT2gNt0=;
	b=ynSgaXSiWc1iEuUpYfWg6386HWU2+2GfWCZvIYLFyFmE9sSI3PisQZNwQx+yTIYsjzSu6O
	DxLOjgk63ZMyt8CrAIiVYiYmbKjARIbx5gMK+aPdaZ+pHOFUpEThBfysG3tVAo83hFTCd5
	5kp6BSDCFCzZfRsZtbnvZIFT7dDeRBQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rlRFL6HT;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777164417; a=rsa-sha256;
	cv=none;
	b=MnER7J5gp4DWh64qXMcTx/wzFcqgWSVeIS/iYD8aeDSvl0RMXAXAlLu6Op95d7bV7QESBb
	mEcTWVfly+tarFH+2JjAGj71L2gQUVAV2fFXvKohob5kwzX/7U/nStWXkmlgEaUgjEUqEL
	Ict/y5BXZB0WYzD1CyM9luR9w2+1IUU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Zy2DJrRJGdFUsSTr714o7ATNF+h3r8jGyotdyT2gNt0=; b=rlRFL6HTN6Uikbhx9EZ/OEyagX
	wyGrCyVHAda/E5rVz1TLqfgZKhtonzmjqC2kLwejrmv2h9kN4l0sK3AXW03khsy/p6A1ZBXMUP38U
	6nN7TnGPbKWp4NrFebCFw26IOvQNc5XZoQhsrAbhxvjZuL2JNfLnWHW/keOxGovt+vH4T1Q7p3qck
	zzImYw1jm9AZF/7YGYcCRUMNDPtokdd28BAFrrVAt+qgbjnV4itZemlJPiCqryxDln0uBevIeaMl+
	IWZLqCBSIukbzQ8SVDIq5Clb8tgo1WZKfxR22JmsxuhgsLkxn+qpEWiP+2OJOBQT8zJjmOIK4GDCK
	q8N0TYLg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGne7-0000000HRp9-3JPy;
	Sun, 26 Apr 2026 00:46:51 +0000
Date: Sun, 26 Apr 2026 01:46:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: [LSF/MM/BPF] Running BOF
Message-ID: <ae1gegHjBsgiMdXY@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: yt78afxqnfr5q9a9utu9efnttdnk8pwo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B03094000E
X-Rspam-User: 
X-HE-Tag: 1777164415-172514
X-HE-Meta: U2FsdGVkX1+zKinkTG6mJ3DDThIfsIuF2LflATI3pFTwDdEpIxUIr+07KJOey0SmxcdrnLYV9+/KCKmT0ZLT5Ll6ODRoMqaahO1T/N0058cHntbeDdzxNnwQSraL1V3DL6jVANcZT5du5S6aWYpq6u3tAbEjkdY5hNhdoebBVWfxgTgfjv1rwIn9b5n073M06IVaoKpaWWqfDW3/alnY17kratbhfYABKD1I+gHEkRL66CYhU7o/DEBR6SWVow1BDl0v+QJt6XbttgrLi8bBISbHqiyXfI8aQVDI9/clYj5nNx9+t6/7jQYfNfSSuzEK7hxAXYW1k1svNe9fmvbTmz2u4o2uDXimBflHZSjJa6QeqwkYUhXVixTUzbVlBlnjf3uvJQB9b2xWH+7ao+xv9rTHjC3bT5m8MLQynsDjxlyAnZijuRYhKP3VsAb/tulI056qAVdTQ9TUyT+Q1xxI+aQbv/rLtEcdRwjly4ce26/cDIUTKJFQfpOWHTrFiS3xnUT5TS0Ys7JuQ+Ex3903kmb/clRCmBuuMiiVp+qebWGM46CVKD335j8dqzbcSCbRhig3QL9ie/GTSHtkCgWTzgDi7jCU9Zvk2VLoZFszSq0PKFSWEWNTLugD4wXtFH0eIL/qdtHWft1MdHW7CKS/WhfOsdHPxb60mwcGppdij6wKMZBRpjUZYZmx3WS91cJmk9WWTy6Wt0W/H/3CKY5jrXZ9+Whf/nfoUFMKsKb6Nd6ZkRYgP25tiaOfgswHOltgdPuVCsDTW/OB9rz6rAjd9q2md8RNCmM7zqRkGUEUn+wY9OoQhJEGu0GcXPsJMuS0vKArMiPNs1NLCLe/H7XKr/Vk4S33Nc9wN+QB5PuKEL8iCQh/yI1QCHsvUElOtd5VDfR/kZW1f4XkNTNxAiXU7U2qt7aQp2SwAFVJ+SksoRj+vOooTG6zWI4kKUa3NprjjKKsgif7oQ05dqK8JNv
 gmnTlESO
 MTfvALFbdcJdh6yYdrdGk2KmW0voabYEKq3QL7kjxeJ5KBYEprtdR/bSJ6yqVO9Fc2/fv5J38wV1jq6XrvjDwR8VyZscIc/IAPlQP/zS9m6q9iSf+is9IxdIuEtB7l4GnsXyPTUK7D6vx83tHP5NTAHv/IDM13Mqhac2dWYiiHPdMyQCM7DH4w2WIu5+i9JhXdu7u3nUdPywJLEP4gEFMMb+KI1xUvurCzN8on7y8BiY4vtagQ/x8TK7asDVQ3OWnJmUXI+XoBVghH7NKBytoeVKvyoYwTwmQuF/CUw+byZvEzhDRKjEjd/lUuFxrxIvtBfKF/8iyA0fxd+vuqossFgaPlCnrlaPcgjQb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm going to go for a run each morning.  If you want to come
with me, meet in the Esplanade Zagreb hotel lobby around 6:45am
(this should get us back in plenty of time to get to breakfast).
I've plotted three routes, all based on routes described in
https://greatruns.com/location/zagreb-croatia/

Monday: https://connect.garmin.com/modern/course/453744315
Tuesday: https://connect.garmin.com/modern/course/453746189
Wednesday: https://connect.garmin.com/modern/course/453747068


