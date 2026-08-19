Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1B0C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D776B008A; Wed, 19 Aug 2026 10:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234B86B008C; Wed, 19 Aug 2026 10:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C8D6B009B; Wed, 19 Aug 2026 10:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E36D06B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:56:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84220160300
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:56:14 +0000 (UTC)
X-FDA: 85118319468.08.9C57D32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E22932000B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:56:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H7hu6XAQ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787151372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8WrC7Cinbzn8XacsRY5ky1hgsA1ofrZsYNCBZdrTR8=;
	b=xLwA3UONbQ+I+zJjxeGejvmkeXhRkp7JHeFVGn2qvA+4LyaTcZmx6UshTlN3DAHZ9kOZS1
	hrXe+i66tpa57ispsBpTSNIfTFfceXyZ4PdqXiRUVXFTXO9K5LHdf8Gm+zq31bflpnsNUD
	6XGL27x3tqRryccPf3j6Mk6xET1FPnM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H7hu6XAQ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787151372;
	b=v5l/SBY8SrQLfBjv1iB7s/xxPswU01BzzH6amKig4HbCb0v52gcz41dRwBuDjPSHdWzkoW
	jZ7IUdYiBGjCaf/PvnDvARycczrikGJb2QBG1PKEDLyqLDFWvY94xwFEopTQzdUhlFT30w
	QynJBig1Zw3tJgA9KAb0MeImPswRoZg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56B3D6136E;
	Wed, 19 Aug 2026 14:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2452E1F00A3E;
	Wed, 19 Aug 2026 14:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787151372;
	bh=V8WrC7Cinbzn8XacsRY5ky1hgsA1ofrZsYNCBZdrTR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H7hu6XAQlGaj6U8q7BwK835aeItmd4QjmvzClJs2EbZmpwE9+VOsR0G0K14C3ihpj
	 cUFc0mmaAqkyHcaYNiYz4Ymm6Mh1MxFR/CCjlB95TtapACDHNu7OwmZecjZvt9Jkrs
	 RY9jHQc81ffHrRsLZZgjJ0Vc4rORC4DAcmhBCkYK7RG8KmVYZRIXiTnd9pRIajwxYu
	 Yi8oMek2rvWBsM2DNv1++FGUe6Z5Z+R7i38L5wyvGAnhfpwQMw22/ysu/CJQu+2kf6
	 KN2tFN4NGRC0RVaC6HpgJ1cQ4RdgquTZBOCzQGhSWsXrCBHc+gTPjiWmgRGK2xFP99
	 cloYBj18z91UA==
Date: Wed, 19 Aug 2026 17:56:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <aoXEBCWQ-a9OB_YE@kernel.org>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-3-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818085702.3395529-3-yuan1.liu@intel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E22932000B
X-Stat-Signature: jwmbx3hftcnckqasrmcg1qx4xhpkkgb7
X-Rspam-User: 
X-HE-Tag: 1787151372-230516
X-HE-Meta: U2FsdGVkX1/0BORkJBjByQLCZwXrh4BjY5aAMRMyMqwIPSTKQuFGXS6qHHQrif4QsnXBBgOUSCtwztnbqVnd7s8bEd+nEuiziHlYs8IzQFH/O35FzfHcrhbqWQKeSHE0S49sSSN64Y0kqy0dEy4CoOLuThUJt42mggt/6SC3oaWNkyAHfGoZIVb6fd6YBJ1lXwGBwdcGzvW63pKT27UCeyhUpeGJMkIgzENG41BYUoZlPqzbR50NuRcXQHbs8LJ2saeLKDaMr4wCIYHcTs/gkoB+poxqgLXQQ1rXJ6o6yJvkalhffZIXP3ivNMmHJUGCvYZ/8cS/Q1NopNBlPVRjgo/IdmVJVDSyUGaVcrC4hRZvET/PXNnb9WfIlyCr+MZtkcGN3uudU0EztuQ0WWF25wJHDJhCJUuEKDu3vXdrLGiMLfGtx114EKjQ/FaoAnuic8ubxLEhjcBrDMTNqaw0+UpjnbwMt80d+/TddJ7Rih++iv5SxmgoCvS53MExAz+O32yAgHWmI11yfW1u5mdhpWiyksSJGv/PrkTyzMRF14lEH9trbawUSDeWRtgynLf5qUNKWxiG1HQxhh3I5w1h4mDPryHzNVVdSx6tMk21+KX1iB/RevgfrBE2v3iAwsSsjm6N9Krs4QMSJtNNCyshJxPKNAlg9MYHuz13l96xy0OAX+CChnGVFROZHJhSGxDxOTlsCWdFNqrUngIp9A1HfmToxAlfjIGpuIaJrA99N4BQAlK4meGPz+Z/pmWOsaBVkYTog1Z1rng/rKZO6Lt9q5UuOfimWZYyHrIIIAO7SKW4KAhtx80jfbNnNuzfVdl+dUCvao4/VQfngzY0JFhZBiyFVXUnKd46Hn7mkJH24lotVdm8iCpHfDBn3tdTdsxN1YIZBsqjVfSfRKMrDOtVhsF37oFjyBWaHuEZ9b8zj7va9B6dZXYFO4fK2tLECvVvQqtqSgx4mSlMZKlFjBL
 voklDVUb
 78wAN72UB2Dp2p1gXlhRj8xwUiiG9V8vAhOis8JxMJoxzx+885qkyw95kAop7mqQlcx5HRKoOn2tjuph6XVyNzkggsHClzOGn0X2JEudtjuXGiy9j4CVKzQ8dp+/yMfd8qM/bBJXHFm7uMqGoylKOy16PI5Dv/oVjP6d9QUGb8GQ7KCv5hxrm59l1oxAFClyRKcVW9VKiSSaLI7EuxF07/Cf7DLebKJNHlUh+ctDxCG2wmHw9PfhHSIlT3zHu6zbSy172VsipayPh80UHVVYo6whq9xxaf2LAJQWMWHyNIGtrqGWH1TomizhwKdYRydJuiP+G3PouxQ733PfUfRtwdB7hrEdolkdOO9nAtrYEJ9o4IYK6Mz4nJrGKvu1GMJtOkDkC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:57:02AM -0400, Yuan Liu wrote:
> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
> to rebuild zone->contiguous. For large zones this is a significant cost
> during memory hotplug and hot-unplug.
> 
> Add a new zone member, pages_with_online_memmap, that tracks the
> number of pages within the zone span that have an online memory map,
> including present pages and memory holes whose memory map has been
> initialized and for which pfn_to_online_page() succeeds.
> 
> For early boot memory, pages_with_online_memmap is calculated in
> memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
> included in pages_with_online_memmap, and hole PFNs for which
> pfn_to_online_page() succeeds are also counted in
> init_unavailable_range().

In what scenario it is possible that pfn_to_online_page() would fail at
that point?

-- 
Sincerely yours,
Mike.

