Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C82CCA472
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C802A8E0016; Tue, 30 Sep 2025 12:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58098E0002; Tue, 30 Sep 2025 12:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B698E0016; Tue, 30 Sep 2025 12:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A92628E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:31:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5542011AD45
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:31:16 +0000 (UTC)
X-FDA: 83946456552.02.F5F2EC4
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84F04100013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:31:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=g4tLbS+Y;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759249874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WetHZJTzEqMQIo9y7P3KIwAL1Hxp/CxTfSyx7CYN7KI=;
	b=K2Fj0SeqJhdurEmqm7cK2ptB38GqQ4MoztuWgNmXDEBj5XKnjDZfrNh8B8IPJEwuhgurIQ
	1hOQlsmeeP3e0t0+vgMVRHsdnaTcqtE27YKbTzxr/pQ76MI2QewfpQJSSogmaWwBW9elfc
	D/GbExgwQibFVFRzEtyjP8KVJBTLt5A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=g4tLbS+Y;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759249874; a=rsa-sha256;
	cv=none;
	b=T7OyywLWeTmj0H4INkHFp3+/U3aMOhscEbrR+vNpK3ozR4mlCsXB0zIRG+E0ccYzm8a3x9
	9ZAAgAw8kEKaYAGfprD/wm2O1Y1w2PKjdnqsmqQTXi8K03cA/plT/515o8ub/HWqlIOozS
	1WErLPLnMYB0GKM1Gy/Mj9oWArMlQN0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759249872;
	bh=KrP72lI1FFAU2CtrhllKwhHy148gk9UN/Wkcz+o+ngg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g4tLbS+YDrZR5+xReW7WBOtYQiZFTrR36tzXP/piGDwK85kdUgalxR2uM5HSxQb+N
	 5976la+hwmd6cqqWFJEocRw1uesEkO9vuDgBU8XOKZQ4ed9iC73uVKYj2Lo7mDtdeJ
	 sOjURRuVZewAjo+vk88vMvrnC8H4OC1nDdyMMG87h/F8/OEHKVxE/lPiryPCfloYnw
	 RFW36AmuyIRWvrSiqblWxrkAsXf2D/4FTK3PTlWJ7Ms0cs218c8dYtxyOkSpzlnQJ/
	 hWMI2O2+ecGS0YsHbbCc4vizwY7B+MymOeEvpVLKnHHsSC8e0GRGl/Q+EK+F8igYJ3
	 iunHfmMC2LUQg==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 604E117E0AC3;
	Tue, 30 Sep 2025 18:31:11 +0200 (CEST)
Message-ID: <d3b927b9-ddcb-492a-a72c-d42abbb11cff@collabora.com>
Date: Tue, 30 Sep 2025 18:31:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] drm/panthor: Introduce huge tmpfs mount point option
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?Q?Ma=C3=ADra_Canal?=
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, kernel@collabora.com
References: <20250929200316.18417-1-loic.molinari@collabora.com>
 <20250929200316.18417-7-loic.molinari@collabora.com>
 <20250930123416.4ff59b11@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20250930123416.4ff59b11@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84F04100013
X-Stat-Signature: b3a716dby6npb61d6yjwy3fqk8oidnyi
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759249874-205045
X-HE-Meta: U2FsdGVkX195OFxh9Pzx0pXM4epwgawhTCfMBRZcMeD5cDhR99lIa295qyBCHuy8fb5gpbQO9O5W0XbMoWPhbICSCDwedyBlm0yyUds065Q8uTL0CwcruI+W9tentxi/DW6lF+RfFtHFgy/atAw2sFzQ7VsGq3xOf6r/HN8GPi977v+nQk+7gPBYiw++FNxvXwGoXlDNUS8NP+Zo3GYD6jTZrH/pLRPgne+a0MIxOktKKDzqXtNjP5wt7N7Mvt/b19fR+MSd3OIg/qCBQcqxa+LU/m5sEFsAm74TlzfJ1nvl0qXuwWmwQa/6fF1JLd7rUZ15yevQE/jnjDsAqK0VFs4WfqgCexnAUcxGU2ngKqKpFszBI05FoPcjC08riTa8HDkNUQ32HIet5MzVfwKkt1aKCvwms3pLulcFrYMQJ4F4+lnZ4S0OsVN4rKNOzJqAEMizaHgaoC3Son+OfDO8DGAmOJhJzMs8RmXy0+2ZGnFJ5AI0WbQ2MN7TYHEDd/Z310aJ/muj3YMLSajidqcXzWqdfM63fiAJSW3RYEIZdWbITOqSoOxCcbQkUBxUnAoq7QoTwj5++4sABp3MyoovhTGz2NWfB4UUNj/raUylmtBkMZwdqWs0BNgaBJmYgEk5ewJU1bgXj8HDqtWdQjAasgPzMTHUKtwE3uAW0vxudsKaAx28PIw9Jm45noYk1hSGA01skuqskqrFoiuF0OZ3eY3DuKFqJ7w7Bof7LB52hk+/Td4lru4Rs1poRlv4Sh+QQuqRjkIufZtipUjiqt4yVFrooxks2RzMCYWJDRwxEguSzvbOrMaJSlsPB35xguJPIgOIqCLt4jwUvH5xa/bjjY/E4CvtSXGUm2fhllYhltJJEggvnEeZAYBnsLU0dmTo4huaigWsGZ9SS0Z+BzOkSP0jOrc9ACGG5uM5J5SRcQCgtl89Bs8MO/tCt2qtAUoFVzCLBP0Av9cATeDM5QX
 aJ7SNUj1
 hahXOwmzlew++Mu/Jl3LN/2yGMymaFFYgxnE2CRBOf1xq+CEPovldR4EqX5pCXzAiqlDO0/aZ3+kzUtX2AK1zYQTDgFaDiA4XMipz1iO8XynyRHYVreq2HEpRq1UAKfMIgjLAP6Sr8PZSGPn3GbMblJ1E4HIkLHAqCLPjlNdlm/jZChlcSisy2s8rgpZS5ryiGJtXL6/uqqdTdhu1GfYoR1M8G0k95yEpuJnG9TON/wtBCPuLzlGTYmsCCgfB0eTYfuF2G+lD4c1RcJ7pUebbe4tt5w7a1OosyJ7Uea+22O8NgPXBPGpPoLW/edfmIXkJ96ISHXK7WGCCiIJFkukNx9sKMAXQVEYl/P7woXYUyxtdu5HAgi1EpNzGnlP3QQ2nCtulEQ4HgYuCrop6s8bUuOdpcM6lXpWAZ3DQauDhryqHUKmAvUMtJ93og0nQ4dsfdsCxmyvv1kOL9yo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/09/2025 12:34, Boris Brezillon wrote:
> On Mon, 29 Sep 2025 22:03:14 +0200
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> diff --git a/drivers/gpu/drm/panthor/panthor_device.h b/drivers/gpu/drm/panthor/panthor_device.h
>> index 4fc7cf2aeed5..54ca61567426 100644
>> --- a/drivers/gpu/drm/panthor/panthor_device.h
>> +++ b/drivers/gpu/drm/panthor/panthor_device.h
>> @@ -135,6 +135,9 @@ struct panthor_device {
>>   	/** @devfreq: Device frequency scaling management data. */
>>   	struct panthor_devfreq *devfreq;
>>   
>> +	/** @huge_mnt: tmpfs mount point with Transparent Hugepage enabled. */
>> +	struct vfsmount *huge_mnt;
> 
> Now that we have a helper to create a huge mountpoint, wouldn't it
> make sense to have this field in drm_device instead of having each
> driver add a huge_mnt field to their <driver>_device object.

Not sure this should be enforced for all DRM drivers since most of them 
don't create separate huge mountpoints (only 4 for now including this 
patchset) and I guess some maintainers might prefer to depend on the 
sysfs interace to enable huge pages.

>> +
>>   	/** @unplug: Device unplug related fields. */
>>   	struct {
>>   		/** @lock: Lock used to serialize unplug operations. */
> 

Loïc

