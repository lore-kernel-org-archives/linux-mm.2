Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32880CD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 00:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67406B0088; Wed, 17 Jun 2026 20:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17F66B008A; Wed, 17 Jun 2026 20:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D556B008C; Wed, 17 Jun 2026 20:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB8A56B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:49:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27AE98FA33
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:49:01 +0000 (UTC)
X-FDA: 84891198882.27.76E9EAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B3244000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:48:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FOW/0VTy";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781743739;
	b=5nEwFSt+/Qztg2WQCYz1zfisDyB4tEeR8+yd3O8vjH4gHltUHyzzRNWlazvUHhCf364KyD
	PSl3yTbPbbeYzkM6Iql8xsbjZchpqKfFz2rHd2WyyMDESf7jAC5Y2CFMQ2bDH1MTfYg4rL
	Q+Y5jjums6ymctjmz29lDnbhGL8+hFI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FOW/0VTy";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781743739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2siXldkd8gt9W8aNqIsv9pczU/rHdB6+j/Y0wX3poc=;
	b=klK5FV+Co/BKNXrrTES8PjuQr+nVrvOGTUwYTIKx8vQanFwwU7pPHOz6XW+tW23RSvd0d/
	1//LywWLSNO+GieS+pdJub0BVgJMx7pJDVRKwNU68dYB8G+vr5KpTvOiHcFoqwdfQPCbVR
	KnS2CwabKuD6b18JPlZEc6w/YmH/sbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC28F403C3;
	Thu, 18 Jun 2026 00:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA121F000E9;
	Thu, 18 Jun 2026 00:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781743738;
	bh=e2siXldkd8gt9W8aNqIsv9pczU/rHdB6+j/Y0wX3poc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOW/0VTy7qryoePanimvF1XJH9LkSYN+89HzcEmjF8nDZxY8jCKJlK7z+qIuQDjhV
	 QfSMAFvXi0bAObRLAiuHuxGLue7nKOWO3DAkgmA+YKHNj+CjYr0F2DzF5MMoeW0fpL
	 9+P75al+e5kCL/U81sPPcA4+ejsRVICHaBOZkFa9kT+1lCPvTmyyj5Ml4BTkgsi6un
	 D7M90+VjWELVvcuEo6klNUWbEgbi3qdqvwFSrhGDELX4gYg2pRkoVBTzG2kKHU0VJE
	 LddkFMVqblXVGZFm2Z5ptLwFekRC51C43blCJgHqmWqrUf5foDR4EHqfQBbH0YOyHQ
	 zm9WHxYkyaRig==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1.1 00/11] mm/damon/sysfs: kobject_del() directories that users can create/remove
Date: Wed, 17 Jun 2026 17:48:49 -0700
Message-ID: <20260618004850.82407-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B3244000D
X-Stat-Signature: f919ycwekxyhejnej389ngn9qk5a7b3i
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781743739-89197
X-HE-Meta: U2FsdGVkX19LuQdkZWVHs/XPEeVBgGmfPZJ2jI5puKO2dTmq+hK5pP5qTkI0ghcLzAAncI5vvloOsFyS/anp+tFdhJ8gdXvCa3vsblI5mzNO8kg2s9+bjpuWminDGMxrw/sY1KmJAaQPVE+MDjSd90IROpX02rHuZCI818aro2z5GoPKxUmyM9Pges3YkD2vmoQuLqQ5n/hDv+xBDwhCXgyyNRGR6hVycMjUdPHj9CivOdJW7W31uIP2gK4mfzt4cchbiSrMT+y9oItXzwf7wZq78ZNuHBBEojwy3yn8OCLNFwyqCx3Jnyy7MUmv9flaZX6MFBU6MqiDyRfKqDuTH+J3IsLSwEGc9dZlNJcZfOwMQLmHhKFwlM040J/9UnawEQPa6IO452my5mxx9SOUN+vdeTx1vOrLukKQs9LZnt8j1xdNFWVXXgLD91rBw1FOn2Mbgr2mR/52hSzcn3CBqO2dv6kbxixwdcJlEkKpregMih+2Z80Wn2zhkkxsDMuLKm4Vo0wx/G2ehsZL6uiTnyejHbhwyqUr4po0EtJbKl/+hpQgT7LKmGWXrf1thdutDJNB2E25EFb7ps1kxz4k5toUFtvd1G5zVV38NHw5NbJ9Rd/Vnkql+lxLrax3LrAMqW+JxMsllW6I3y6nZ22/gwrMnRbPEVCC/dN3e0ElTEOGjKCm0oD4xpItMQQD4b5cM9VfoXi0+hi+sli3lXyccnfoOHq4jwBEkOd7mwtSON5LioZLrlzD0cD0jPnXGQ8r8ohkGrjEv5R55a804kKAhKaKSVuc5UK1lwzv6Ad0gyVtdMEPUBr2m9zz7RxsOlrpodp941RlA1p93PboygPp+lyOhLzaJmdilHUPjer6HRGF8+Tw65fAPFvq9qt9I7RzlCzu1yMP5m3jikY2caXQQK/tfO8R8+J0hAovcqiDF2JlQGYexc/WUfunte8FSkugPjbYExbEnOgYzmV5vLX
 lD0VCBqH
 opJ39cZFABO5BCuvluwY04FD5FEsbZFGJOOiX4qTjN709kuv14uSwSQtQi5qVVZbCpdpe6pioE3LqLzm5vrrgeltQzuYmNvaduDBte6nya6zlfBn/jNmZZUKdxVmXbZ6gVwfZPnWjtkGYdFcVOA5I37VPDXI2oSYmkF8e0boYQKrRzA21lKVQQKWpvpARxknVI4NFNMeXFmq74wWpbyucC6JsVHE+4vuSpwy8TT0LD2yi0lUx+PZ7rBDf3X1m7dgr1+8pQ8cdyeDXk8gWJgtMl+VdZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Jun 2026 07:47:54 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON sysfs interface allows users to create and remove arbitrary number
> of directories on sysfs, using a few files having 'nr_' prefix.  For
> example, 'nr_kdamonds'.  When the user writes a number 'N' to the files,
> directories having name starting from '0' to 'N - 1' are created in the
> same directory.  The pre-existing number-named directories are removed
> before creating the new directories.
> 
> For the removal of the existing directories, DAMON sysfs interface use
> only kobject_put().  Because DAMON sysfs interface is the only kernel
> component that manages the directories, there is no problem in normal
> situations.  However, if CONFIG_DEBUG_KOBJECT_RELEASE is enabled, the
> removal of dirs are delayed.  Let's suppose a user writes a non-zero
> number to the 'nr_*' files while there are pre-existing number-named
> directories, on the config enabled kernel.  DAMON sysfs interface
> decreases the reference counts of the existing directories and
> immediately creates new directories.  Because the removal of the sysfs
> directories is delayed, it shows some pre-existing directories of the
> same names when it tries to create the new directories, and fails.
> 
> For example, the issue can be triggered like below:
> 
>     # grep DEBUG_KOBJECT_RELEASE /boot/config-$(uname -r)
>     CONFIG_DEBUG_KOBJECT_RELEASE=y
>     # ls
>     nr_kdamonds
>     # echo 1 > nr_kdamonds
>     # echo 1 > nr_kdamonds
>     bash: echo: write error: File exists
>     # dmesg
>     [...]
>     [  300.880458] kobject: kobject_add_internal failed for 0 with -EEXIST, don't try to register things with the same name in the same directory.
>     [...]
> 
> Some of the error handling paths of the directories also lack the
> kobject_del() call.  If the user uses nr_* file right after the errors,
> similar issues can happen.

Sashiko found [1] one more issue of the same class in
damon_sysfs_schemes_add_dirs().  I will fix it in the next spin.

[1] https://lore.kernel.org/20260618004428.82261-1-sj@kernel.org


Thanks,
SJ

[...]

