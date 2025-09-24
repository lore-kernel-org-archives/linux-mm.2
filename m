Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16672CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 16:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBC38E0006; Wed, 24 Sep 2025 12:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493B18E0001; Wed, 24 Sep 2025 12:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D05C8E0006; Wed, 24 Sep 2025 12:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC8B8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:35:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9E681408BC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:35:07 +0000 (UTC)
X-FDA: 83924693454.22.5C37EE5
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2DEBF18000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:35:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758731706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PBaPGEeVNMilfwJk8i8YSVBF0wwpJqxASzcaMfPpYbo=;
	b=b4ndUlePMYo7vQIotDdGoe/+J9xmkLj/uhHebDPdRyI1/Ncf6l1PqaXOy/osxt5T+UCphP
	lkZHR0z75VYW8ksi1gKJxO4kbg/6/w31dGhLs9vpdMQ2SnrxKhVpK7P0lJUPUccHFc+jZS
	1i/mJfCqiEstvFdqQO3tul0aep82y9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758731706; a=rsa-sha256;
	cv=none;
	b=kT9GnoQkBQHhaCg7iWJlnqkKqEtM/v26uLYREYJE72ln/pd5XugkrhpqIOsKTf0lxh8Ls/
	EYzHpueGwU418HOYarkVYpvv4zvZfrQ6EE1mnvc1hFV9UlijRaAA2k2OB0lJxIU0r3Fc/Q
	jA/Jz6UrYck9mhPJb15ZO4MvD4nh6Yw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 25 Sep 2025 01:34:52 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 25 Sep 2025 01:34:44 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNQdpCgC6PDLegr5@yjaykim-PowerEdge-T330>
References: <20250924091746.146461-1-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250924091746.146461-1-bhe@redhat.com>
X-Rspamd-Queue-Id: 2DEBF18000E
X-Stat-Signature: a3da8ui7r8m8jqxdp14i5sbteq4cgogu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758731703-829899
X-HE-Meta: U2FsdGVkX19r4ryf2DWL/Nqg5nV8/GwcxdBTdPw5y/rWEprK6i1tfoNGE9t6HKI97ITJ6b53bperd/EMX+aRebtC5VGCsvwXvtSdQhM2B8MS/Z88KnoIB1ZNN+aRooH9Be7kTsTwhOwrd1DXXCESQotkuOjwGVRPvC8qHMGzLbLczVE8sI6gnHNctsAehiG2kLVOaYiRTnHEuZYm4qwTmeW//+Vo+4jNkUWAIBh3hDQH8NppzqSxsSoW3Ne0Qh81MTVkMZNWzm1USfuVdXvN1qPmoqSIF0t3TAbuej0ucVbMkuJT667FR6fw+O/reeUi3MEI3nXiSIcJIO10swESrQpNp7aZP8pGudpoXYhTfLw5TDWsQBEbwc3McQlhHkPUlWN5oYYO1U1LtYi0nPsufnbYA/10BFVadHQlEWX6LWvCaWVVUvPF0Xt+SgxfcRzyOguC9Wp4PM0RETB5c+acWYPnKfibUQFYa4ccwgbnTNXT1zD5ITc3c7MWFS7Y6u26GQCijEL9hjahQeMRAaJb4vG1845dZsnNxs9yOJodC3J9GWGuIKWIDZwAvkwrZE5ynQVQ1Kp7BcxncqVEaAfG8tcID6I+WRTPaiE7UfGir/XqDYP6ujh+eC3a3wVeRTo7gkhBARCVvVXE5dREPiqJmrLm3Q/a5bGO69l54kZ87YyZdAFeoBx/sSzAcPQ8BW4qoi+nPmOmiGsU0CiF6yDwB3XQQQGUlyaUCpdZHiSc2hf37QkeBEZWw/DP+1q6sxFEzQYbRm0E0t7ANa4pcMmwxTVvO/N/hn8tx7KvdJjx0u8VXAYuoLn9NdApP46MjlF7jGIWlKaCOlrlbJOcmTYPiWg9q2K6MwXNDHHntwu10ohd6WVh4lLmnBA+9ixET32Y65pfKZKIVY9KFfcM8/2yON4L0E5jVJ10LTzp1ZAMWNEcdMFhWaUw0Z7moF2zeLEw+OHR4721pfA37mIIYCm
 HRyyqJVr
 qlvWxsMIUpq9IcjHtzAbcZ4Ji2iwiEA+tn+hKy5gBXT/x333lPc7pxlYV7pEs7sq+nJxXSNAEkcRXjAXaiDEkdJGpM61yNA4kpJglIJZ0cbAj3ieQZeUXp7ASlNCroGtsFCwqIwxxTKgq+8gHirnEz5UJFJjViHlpNpTRca2ovMTiknfbFam6dv5PwVrZrgMXs9gR4I3Jn6TsXAbowx+4SfE6/rFSzV7eEcNTF8GheJ8x/eg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000007, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 05:17:46PM +0800, Baoquan He wrote:
> -	int i;
> -
> -	if (prio >= 0)
> -		si->prio = prio;
> -	else
> -		si->prio = --least_priority;
> +	si->prio = prio;


> -     if (p->prio < 0) {
> -             struct swap_info_struct *si = p;
> -             int nid;
> -
> -             plist_for_each_entry_continue(si, &swap_active_head, list) {
> -                     si->prio++;
> -                     si->list.prio--;
> -                     for_each_node(nid) {
> -                             if (si->avail_lists[nid].prio != 1)
> -                                     si->avail_lists[nid].prio--;
> -                     }
> -             }
> -             least_priority++;
> -     }
 
Hi Baoquan He,

I noticed that in `_enable_swap_info()` there is still a comment describing
the behavior that this patch removes(auto assigning priority). 
Shouldn’t that part also be updated accordingly?

static void _enable_swap_info(struct swap_info_struct *si)
{
        ...
        /*
         * both lists are plists, and thus priority ordered.
         * swap_active_head needs to be priority ordered for swapoff(),
         * which on removal of any swap_info_struct with an auto-assigned
         * (i.e. negative) priority increments the auto-assigned priority
         * of any lower-priority swap_info_structs.
         * swap_avail_head needs to be priority ordered for folio_alloc_swap(),
         * which allocates swap pages from the highest available priority
         * swap_info_struct.
         */

Best regards,
Youngjun Park

