Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D10FC9EFE
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 14:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194256B0005; Sat,  7 Mar 2026 09:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141546B0089; Sat,  7 Mar 2026 09:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04DE56B008A; Sat,  7 Mar 2026 09:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E59086B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:00:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 924CDC2C39
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:00:20 +0000 (UTC)
X-FDA: 84519426600.23.4BC3905
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id B9ADC4000B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:00:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SPpZEcm1;
	spf=pass (imf27.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772892018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRAH1OwRMd/hgomET3JR4h+I3zPtNpk+wbuNofTgx3o=;
	b=SnPL8zBjombvp0K1Nrx+yYPqmQzBC4rHkz86ZMAuwEBGNwyb0rmu8CKZ2+of6G5X/nDq/r
	+yC6qe5q4QkBUi5Nc3PmeQqul29H+styeTsz98MxIPN4u0bZBjUVnjfny9D/CTdya/vEtk
	hOzYtuuC5lvb03tOM8v6weuFSzCuFFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772892018; a=rsa-sha256;
	cv=none;
	b=INyfmV5c2MyhX3yYoF3SnLnRAuBGGMt5cpqZpc/pe1zHUWa0xXCi3Wa6Yc3JK1BmL6kCdc
	tQP6BvLOAVRK90421F5z73pN4xrAaYuF453mUzJM6mRy4o2jJ8ICOp1di9mITeEkUs0LUT
	355CjirZXLQeCqfiTMptMg+0rGbu2RY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SPpZEcm1;
	spf=pass (imf27.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8299f1ca894so989507b3a.2
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 06:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772892017; x=1773496817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRAH1OwRMd/hgomET3JR4h+I3zPtNpk+wbuNofTgx3o=;
        b=SPpZEcm1+X2GrTE4uIFYErH5gKofLI7mYgown/kde+XhW7rOLtC07gihlzqDkpVGIl
         2FTerZLjVGy6eOjcZSF2euUVCv4s4nAsgUWpD0s4ayZdDL4CmxP5YqrBJOC93H2pvn8a
         akgHrArm91IyWDLh/iiN4V3BBPfuA5dbW3So3VAwhDKYoAcF0Q6XTvpDv6/60Oic2L4m
         pAPrXHEb1JLUY5jVas9GwP+Ej/q0QtMY9nqwhW4lVIDbm8oM4Ve1hidx23v3IgU2fLbx
         gvgd0MWIdp2RmByS4Pcx7bZHseKP2nv/2fBRb0UZPezOsaLysvxwig+VGlp+KzlaZylK
         GElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772892017; x=1773496817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mRAH1OwRMd/hgomET3JR4h+I3zPtNpk+wbuNofTgx3o=;
        b=D+ZJnKRPv4hADujbrdIjFP2Zwvk9AF6OqMVQhle/Xqf/Np6XDxEUDzECPah8gQ1AQw
         thkD3Jes9qxdEObrlGJ3TdBTH8/tsX4wLkUru2YrgFhbW8MYR8tzh+lCBkzkwUxkufxj
         6LHQMK780te4QFPVn6UETslwqU8t5ezkMeHFYZrC0V6A7eUVIdu77p4wQheg83vq9LAv
         nuCPpSwLHQUhVaKuIinyG6e9B/q4o7qNKTJUqk5v9lH5tlV1li2aR69Pz/fgCg5IT9Kd
         yTteCdIflf9oI/8nEOWpUczIjlJo6ak4RAXHDX/cbIiuXX+Iqqz7aQurnogcL0wbNas1
         LLsQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9y/mqkARj4Lt5RJO7SVHLdsYOOOSnNkGw9ulyi/MdZLtcS+fM0oB5dtRcPdJcTZwWrDbcLZDOmA==@kvack.org
X-Gm-Message-State: AOJu0YxQeL5L4O5gYFBr4XovNkYQGRT7wDW/Ry0YQ2TKWvicQOS3LrVW
	4CF5H8OisFP9Jn53IR2LVIm8+8l/c81aQV0tDKISdVULr+CBhcXtK9vK
X-Gm-Gg: ATEYQzwDkOPDupvc4wL0AOAJ7xzuTuALSxl4sbX7EdOeoqnFwE9YkOvYnNkgxepUSM4
	a0u27Qd0pJ+oIvIk9IhE4T1HXM86tfeaU4/fLE6XtgGdYRLlJRcQJ/NXVUJMsAomEp48SRLTxCo
	G+jbE3OGALihyp2QeRoqUIm4yPmMAsDiQcX0iDwS6alC7Q/I+WssH5lu/Z7sldQIpXuMZZxiMnh
	VxcT8RQs+CvcB6808azoaiSUJfvbhhPyHTFDXeODYEJkVQINeL+PJXa5XPMzk/ARSXyhHCUFD+H
	nyALdaVvjPJZ2TNc+jReC3FUpgYBcHkeHP3bO0vaG257tQQubmLdSvKXW5mBLMpGnnm75+aBzLV
	OMY1DzHzbjPmd0blAlRk8N29c2CYZQ4gnirohzDmDT5NwFJ1gkg0OE0jsLCyE9NxV2fzw3g9pe9
	1O6O5DwTNjX54eDy8/F9HYz8vWNlXiOIrk
X-Received: by 2002:a05:6a00:7087:b0:81e:f1c3:89df with SMTP id d2e1a72fcca58-829a2f808acmr4078268b3a.50.1772892012838;
        Sat, 07 Mar 2026 06:00:12 -0800 (PST)
Received: from zjh-MS-7E01.. ([2404:7ac0:6427:b7dd:ba81:85a1:e5bb:852a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a4657a10sm4291425b3a.21.2026.03.07.06.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 06:00:12 -0800 (PST)
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
To: peterx@redhat.com
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	jianhuizzzzz@gmail.com,
	jonaszhou@zhaoxin.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mike.kravetz@oracle.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	rppt@kernel.org,
	stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Sat,  7 Mar 2026 21:59:59 +0800
Message-ID: <20260307135959.44974-1-jianhuizzzzz@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aasGkA4r56pLqNC3@x1.local>
References: <aasGkA4r56pLqNC3@x1.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: itwyd9iuw4w4qhhu19o5wamigz84nkrx
X-Rspamd-Queue-Id: B9ADC4000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772892018-593047
X-HE-Meta: U2FsdGVkX19rsvuUaqiheMENhsVajzU7AOWyB3N0Q13CKrblrYz60dphv6lPPhJ5s+y+hCbQVQ36oN0fiD2iURZtAFDeUY7uKr2lymHpHQLs6zCp3iVXHJwHM8PIkGu7iQoYxM//ESTx14C7P+PLD3NJXIvOCT+lKYHLfCIzf4NLc3sWTGtGQrbXfCH/lGfcd5zYK37OqufX6yjrK7AkiMUeGC/Q7hp2DcPGW01HxT2rLoZTwr7tXtbYeZGiLOOPu6TEV06DVzfxEPSFyVw5inZvuZANr7XKnu1P/T71Uk0wy2SM3vrtrGBKvFNVgLI9BneMxMRcPIjUSFBUaiRfJS25SLVYzlXek2gABZUnmZrzdB1dcFm2xC503goqphLaSDugSJabZG58YoKSoclFoPyG29isXxuzcMHB6VLeowvByo5d7sqZgVF0Szc+NhnVn3w6fiUX/a6HVb+ruzYQrJrbDlC+STHJZoSp9McoPp/xTMK6Qs2xY1dfQPYQaOccXRabZ60PjfoFPaMlhXwAyaB/OPwq2aXaWVANwnQQd6LFBHLSdguJfVqBgO8eqWUAgIehXEg2Ni+c4/htXBJuIBNsERgEoaunqxaXYycUXJVi/T4214nkBfeuAtQQzD/XQr/xA+cceEK8MR3OXVLBcD4JfdrlvR7dXyHrboXk4W7J/pM6xD23i/OgYJbSgsTDBvPiX9+keMXp1tys4ccQQPZXo9xfiqz4qA/WDRSLdzq5VTnvGqwAMsInxRD4sK9KqV7RPMiPNRSh+kKHK46CGkNb5LVEfVMWIQNY3LkDtYe79SPDT+F6grjoT12j7734iMETOFL1MXyN738pdfM1nEFJQ+J1AciLPCHEbKOdxbSJqYcJHs+SWt/7F0lJya4bAFgEjCWJnSYnWHyierEQMu4iRe87Vi4evaJy9yL+/kjrVe+EpAe2vqGjnZU3WeUD84KQfbLGZREzI0hEqCI
 q7clwO0p
 EbWqqYdQd1TG38kY1Wtw4wWQGg6sR9GogCLAcT/HRM1Sa5vR4ffeKCJJoX1UvNFQdzKdoarSj6i6Gg54IO6cujweHcOBijdgVJK4xZN/FL16yh0cd3At1GXuoVB/20SPVP2y86bwhhYLHT0xe19LGaCpl7SgfilwDasOOgTsDpD5f5S156an/6SUjtsWkbj6mCp1ovR7jUT8KoTBI68hzjRL7EYv5aLasgghn4Mew5HWRM2+5k7rooWNbsDPnPRUmUUEzCQ/e1lMslLu3djf96eg/VPFl7ga66K1wMzTfTIDbBo0xtXGsZvUMGq9ucvn/e3EGufk1lpuTfmo/5XMUjJv9j4CaVFziAuBC6Tj0ptG4rLdsFw7OFjW7RMhefMies1Dc09SRS+hBaPFa/GeHufGbjr06dU1wSDU33Z41CsYotUwWHhdcDLqzCc4To11nI+6uecTluHio5ddDkC4ETlNeNjs1fzTEcJIP+m3QUbt/W8pGqMFc3eEAMYF104PAhkn6dX6CMmUx8fi9B94y7s/umy2SuAaPRyxSGjDP7UBm9GKmgCNxCGD3Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 06, 2026 at 04:53:00PM +0000, Peter Xu wrote:
> IIUC we don't need this; the userfaultfd.c reference should only happen
> when CONFIG_HUGETLB_PAGE.  Please double check.

You are right. mfill_atomic_hugetlb() is guarded by
#ifdef CONFIG_HUGETLB_PAGE in mm/userfaultfd.c, so the stub under
!CONFIG_HUGETLB_PAGE is not needed. I will remove it in v2.

Thanks for the review!

