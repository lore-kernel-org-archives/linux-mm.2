Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0958DC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A636B0095; Wed, 16 Sep 2026 06:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBC8E6B0096; Wed, 16 Sep 2026 06:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB586B0098; Wed, 16 Sep 2026 06:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A40656B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:59:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 346C81206A7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:59:41 +0000 (UTC)
X-FDA: 85219329762.29.1AE89E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 83902C0008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:59:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAql0rPt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789556379;
	b=3CSxnYNkchdCQIsYZUQp6S1t45rKLBOR3W6fT2guPJBxsTIDM1iuKMU7ZCJFsS0MiF+vfU
	8fHBrDwya4MmoBJ47nZftmqDZG9LbGqWoXDrCcQwhIZwPaVkJlwNhciJVNApeEgICHuXR2
	ptufbMnXNXR6RZFDjauPFVMLhEvkRBU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAql0rPt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789556379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tc4Aai0SNxDfo1WleUJPJGNkJ8xTAXJ3SVOUXDOmepE=;
	b=E8E25fK4qtblo9tVYS3BZ3O4jo1ZFBn7ZU+xmW6YyCwHkfv6JY5yemJplpu/PAZ/LQAWax
	FvjKqCMcVZqKJB1pWZhERukdB70xdA+k4QTrfLbkxsHiEC4r0gPN7JgrcRsRmbz9DD7cUz
	kscpT9r50iMShZQYP73Job8ZyQyRTZg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0BF943BE1;
	Wed, 16 Sep 2026 10:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2864E1F00893;
	Wed, 16 Sep 2026 10:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789556378;
	bh=Tc4Aai0SNxDfo1WleUJPJGNkJ8xTAXJ3SVOUXDOmepE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LAql0rPtvN5VzBdHGrrh/28DRXddvV4XNsfz7emfkcWzFbpvCnlr1v9fPfik/3GNu
	 oQIH4coNS8f4gXlb1t/PXKzMN2X/OLhhF/G22WPMrfA+fyx5lJVR7pR4VVbawRrM0c
	 sfgZQFx1l/TtxwgjTfr2do/TkmhGicmOFC4UuhhCLqY6Mlwh7dFSop8+ryPaXsvLSc
	 wr5lV1pv0O36ymg2AkdWG9hAGP2clOuagYzdggJs54UToGTpf3aDDXpTn5n4qyy/Oa
	 F4lxmrwPTLEoVdkhKegoGRDADlwxt+Bp4eeV3NIf/KkBM0WJqnFKaiV35rTXZKj0aD
	 3xyN7hV1fg6Ug==
Date: Wed, 16 Sep 2026 11:59:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2] selftests/mm: skip khugepaged file tests if mkfs.xfs
 is unavailable
Message-ID: <aqp16Lp3mPwszQUc@gremlin>
References: <20260912202903.16157-1-jaeyeon.lee.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912202903.16157-1-jaeyeon.lee.dev@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 83902C0008
X-Stat-Signature: bmfgr6aafdx7e8yfgc6rdnsfyparst5j
X-HE-Tag: 1789556379-887634
X-HE-Meta: U2FsdGVkX1++D46VSg7S+yJbB+x4mqRZ/OdoIBnVIV6zWgJSMJdpGbOWxYq5z+c3SvH+/ZJJMVJvF4EXjIhf2oA1Pg8jd3HwVuJVvlqZsh4keElcXnrx8klRpLgoVPncHHDT7JeAZVyjmiF3YSMaMZv9EZVaMiioLWulLldYxozXMcAyGLKVqgZbDVx71f9kS2ETUtPIB/T11rTwKWeuwHMlCzbVMBiUSw2xY3qlF+uAS1hzFOj+JnCFhvImeKUCrxbD3R9HDw3qJACr60RDbDDU63d+IzWpD828XEdYkS4tMqOo0GThtp+H90H2L4I27HCuJNl9wH2XrixNvrbT4BZ27tSCB7n4q7D2RdPmuZy236PbmuaFEaq0bImPDYoFzqEjoK9kiZUJprIvKQ8it6vn4x08RNeJe8GTKzcu+bzR9d1Rpu6xUJFnBsuJ9p2THcrfTet1jaRqypaQTeBOSUPqAl4eixpVJhl7M48C4mLEU2TU0h/QIHZGPf5/sg229oHAa4fOXnGLpYk7jod9JDWnWEeVKXLzJVLIAnIBx0fjy594Xy2kPT27TvCaUJ1RQmN6qD+f6qTETaRmobJrcM3OAc6gljeenlHqY1vtOSI2pQX7MLkaa3MWkI6+7Qot2xgEV4peX/D1HWnzNcxYk7+HFLjulB0NnODF5pwas2fDp06/oflbcVJU6aUUO/3x4ZWDc27EcvZ2c09RD21oFSVwhqzi+2ZGq6Itbq7gwbE3h9iu8qqAvvujrluA9i73g9S2cY9w7okVVlZ1IL3w11Q6YLGuCOX2K0QyBQiAwhaTtW4O5ljGXO9P1pgcHLHygOYay/ptAsexk9kTE/9CGujnDM/mrgryTjxVqzraQZQZ648wqMIrt9VYBbX7LnEHqg94tLOm/laRaHQnJmoBQjpU48jzdM6yrZ9ihVsp1BC16Dy98R60iUv6EsZt3lzxRnPOJNEa6CBA6PcpJw5
 wsrJo3x+
 bsGBDv/A64BkWFGZEOAROwXsC1MlQbj5SEdsJVGLXyYH4daDqwztACL4HxzasYszik2Jb3ZcIQiJSNAoeuDHQIWotx7LTZpdWy4HP3dtPqD9FsjnSQIqdslKfHyNTQMkL16mHpc/Qyf6qn4uTq/2znDijgEtSlPIUxoOBQRGKhVK/RBc+/NU+5jIcqFckItwx/Y76+cMWQY428a5ZsiANnaxC7q0di8AA+y8y3/sC6EQT+JUEVDmYlXpO1JNwi5J5zefONPT011sVBZQ/0HHt/qJOPkE6VgFJSXtnonWZfHO4WGONbxwb+hIQIKcyhhRnE6rsrf/NCh3wiWYf624XdGt8hrUAZYtkKSjggLTzzp+SE5a1lsbVJA/aSboKB8JWg7JH34pmcleTB7dgZOAvN8pWJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 10:29:03PM +0200, Jaeyeon Lee wrote:
> The XFS setup for ./khugepaged all:file checks that the kernel supports
> XFS but not that mkfs.xfs is installed. When CONFIG_XFS_FS=y and
> xfsprogs is missing, mkfs.xfs and mount both fail, but
> SPLIT_HUGE_PAGE_TEST_XFS_PATH is assigned from mktemp -d and stays set.
> The test then runs against plain tmpfs and six subtests fail.
>
> The script already has a skip path for this test, but it never runs
> because the path variable is always set. Assign
> SPLIT_HUGE_PAGE_TEST_XFS_PATH only once mkfs.xfs and mount have both
> succeeded, and remove the image and directory otherwise.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Assisted-by: LLM
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>

I guess you didn't propagate my tag as it changed a bit? Anyway LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
> - Attempt mkfs.xfs and mount and fall back if either fails, rather than
>   only checking whether mkfs.xfs exists (Zi Yan)
> - Fix Assisted-by tag format
>
> v1: https://lore.kernel.org/linux-mm/20260911124517.63714-1-jaeyeon.lee.dev@gmail.com/
>
>  tools/testing/selftests/mm/run_vmtests.sh | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d09f9f6a384e..b870d21c055a 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -417,11 +417,15 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>      if test_selected "thp"; then
>  	if grep xfs /proc/filesystems &>/dev/null; then
>  	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
> -	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
> +	    XFS_DIR=$(mktemp -d /tmp/xfs_dir_XXXXXX)
>  	    truncate -s 314572800 ${XFS_IMG}
> -	    mkfs.xfs -q ${XFS_IMG}
> -	    mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
> -	    MOUNTED_XFS=1
> +	    if mkfs.xfs -q ${XFS_IMG} && mount -t xfs -o loop ${XFS_IMG} ${XFS_DIR}; then
> +	        SPLIT_HUGE_PAGE_TEST_XFS_PATH=${XFS_DIR}
> +	        MOUNTED_XFS=1
> +	    else
> +	        rmdir ${XFS_DIR}
> +	        rm -f ${XFS_IMG}
> +	    fi
>  	fi
>      fi
>  fi
> --
> 2.43.0
>

--
Cheers, Lorenzo

