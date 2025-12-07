Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F75AD1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 09:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B8C6B0005; Sun,  7 Dec 2025 04:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC436B0006; Sun,  7 Dec 2025 04:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA976B0008; Sun,  7 Dec 2025 04:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 557B76B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 04:13:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC55EC0771
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 09:13:17 +0000 (UTC)
X-FDA: 84192111234.21.2DF5642
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf12.hostedemail.com (Postfix) with ESMTP id D132840003
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 09:13:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=h3vFmyyz;
	dmarc=pass (policy=reject) header.from=fb.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=843621ec3c=amastro@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=843621ec3c=amastro@meta.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765098796; a=rsa-sha256;
	cv=none;
	b=dxqC/lcI8rqRDrGug8z/fLtWB6B0XivTkYufbj2O/8EoG+6b3+XCuD3BFVD6qESHwY2F8g
	J7b3UhE4H06vqzLGva1URLSf8Q2GdWXXSZgTMfz/pnHVpgFYWqAwOkoXgk+O42G+a3qTGe
	FXi4+Dhv9n4/pNRU5VZedBd0RLepCYM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=h3vFmyyz;
	dmarc=pass (policy=reject) header.from=fb.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=843621ec3c=amastro@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=843621ec3c=amastro@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765098796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDlVOO4f4jLAtS9IkeS/9IQLKfCdvmm9Ok7QfBI5TfU=;
	b=bwX9iS3nk85s+OquKVHboTLqhA5Ko8v0Dip/zBGqDMh0Q9zeFoAEx14GQwAmm1bXJujkqH
	TVrVelJ4WFsIHxbh15tRBVlHNb0UNj8gS+QRZ4HKoLSeaR1UGZZkJjqQ5ZlPFWayjVqDe5
	k2EvT2PpfcSBsfSw7Mpg4As74JxMrhY=
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B79BpKM1056663;
	Sun, 7 Dec 2025 01:13:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=MDlVOO4f4jLAtS9IkeS/
	9IQLKfCdvmm9Ok7QfBI5TfU=; b=h3vFmyyzFQZlcvxDC4RX+Io337UfOupkB3ps
	lbBnEwkFb6xeEPelHp6gWcQtCSbyszT/wKXehF/DkQGXR4I4mVmRFArNSdeeSm6t
	KNN0cQCAfHT3TjtuXJvqentwhO8cqzVCq0Ft4rE6bPji6kjnPompCXlgBIYGXeAo
	zMIsDx6paoCV9jzYv7SqDCQd8kOp2A4ijlpcnz4I/4R03HAy7o9r17osRq7R0Nft
	66//SDNWtFMkOOss8Zp6vK70IZ4J24LJ9X/CPsHsNTP0qP5iHtoyqHsA9rmJg9I2
	XEBtmSaBiUzQIb1801oBUiMsXFt8SAgxMwAtOTtJ5Sh/bvCseQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4avk3h3s6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 07 Dec 2025 01:13:11 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Sun, 7 Dec 2025 09:13:10 +0000
Date: Sun, 7 Dec 2025 01:13:05 -0800
From: Alex Mastro <amastro@fb.com>
To: Peter Xu <peterx@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        Nico Pache
	<npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
        David Hildenbrand
	<david@redhat.com>,
        Alex Williamson <alex@shazbot.org>, Zhi Wang
	<zhiw@nvidia.com>,
        David Laight <david.laight.linux@gmail.com>,
        Yi Liu
	<yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
        Kevin Tian
	<kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/4] mm/vfio: huge pfnmaps with !MAP_FIXED mappings
Message-ID: <aTVFIdUJcCQjlrdn@devgpu015.cco6.facebook.com>
References: <20251204151003.171039-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-ORIG-GUID: rYM6VHrLaiGfh2WtIn0VoaPTRfmLm5To
X-Proofpoint-GUID: rYM6VHrLaiGfh2WtIn0VoaPTRfmLm5To
X-Authority-Analysis: v=2.4 cv=eunSD4pX c=1 sm=1 tr=0 ts=69354528 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FOH2dFAWAAAA:8 a=m7gy3HII4n3VcIQTDVgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA3MDA4MSBTYWx0ZWRfX0TmA0tB2xvRP
 HsbJlb4gLpCkEB3XVUB7P8A2XzW7+l82bAsnRz4S692hRozxpbJLVJni4Z0uf4IPoBXkUgPoP4H
 OxcwpZROFi6sVjPORqKT1jeOsaUaM3fLiPBGVDHx0+ilM6E6c3zBmBc8MSsazlHQGb60xp0y/CX
 mChKP0Q2d1cmFAbGaVr8e3wSJ+E60i1Ysfk6kAIaHXT1efJoEo7YhfTDZjpUXmOqsLQjCdGX15Z
 PU3D2TlQjaKBjQfDmulUgW3Q43TAIr9fDPnmAxCzohOmn768lizyX84jYUj0a1xwOdEfD7ctXot
 l/8d99thZGtCSTcSftN7RPUq5TrQiWkxeOY24cBNF+tXYyD9k7ApDKM2niwel8CYERYZG+jaxUx
 NE8gnNj34kdprJW/W61kLdQMwvbCKg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Queue-Id: D132840003
X-Rspamd-Server: rspam10
X-Stat-Signature: f5ssbxcidx7jdoiu7449sr8ugeoi8uia
X-HE-Tag: 1765098795-574750
X-HE-Meta: U2FsdGVkX1+gNSRmYnSv668KsNHgtNXigj5cguHcV/FN893K3PoHWUoVv5bjuzqUfbZRHnYqbksUTjfG5Nr7nbi5sXLN4pi2tPmAmJVEqLafQpJAgKr50GbJF//i+M6o7zQNKCWqxYQlSiihyh65uzSG41ZAe4vF9BaljD/e+vkA9EqJvnWCnRpgoQmX8C/reaQuv0sDCfoRqW65oGO+JjIxsY+eRelmyruS58vEhVH5H+YQzmgz/KhoPIlybLlgrOaY/vbRZQO7G4v8Hmb59sRUlm9eUh7S4gcSeVRAAKkzJdzQXn/xiChDklLlDgfMckPUTY0JfXwBpBK//pPuZjokSaqKUhnn1wm/EINLUVzaV12I63RbTKRlp66pNQzjX10D+iOhdx1hy2ebgvQeYhRagz1w65waHRt8ttII5LUPEsK7cI15DbdsAXhJA0V4QZZDdqzL5ddbeBu9xSn3W5/TSloB9sDnYYTEcMxFFbbiFM1XDqEvzeaOL2KyWhL0i4zaSCdCjobriXSmeT2WgDvi8V+XhTfwiRk9HGDYxA1kRyLEIN9lVdAM1KJoWsIFjSffPwoX9pDSGoHwPrvvJFTdJ8Ox67FNy+ZgYJOsEehZkNfWpIL2fi4Z+eI6yyN2zSGTGMZnCFIfqlwh7C7I3irtE+x62BTEUZF7FBGb6hEiOrgBvPiguUc890vPATb4K99JtOlTMKVBZgYZjfysz8DbwkFK3hyCcpJv06WHJPkJpw8E2JL52BnM2wpWC00ZAba1p/ge6Wj8R1Rt6BUykVDDkFt8LujrbPi2wFez9B8XXtDfxzttXuGERi3Jd8if7AcIj/pnJGWA4xFZqf0hjFMiYc7Yf+naqoPExl0vnwh4HDMLxRmFgogYzZye+Azsmi+shF0r8ERHLxsF/dEkwWUNseKMnrIZue55in5OYPWurTVIbddfhCtuTQOpZo9WwlBcr/s3RCnGJi6LYRk
 rWFMyN7/
 rZXbBK4rPZLs/L+n4/f7bWtej9NW592bFPKY40IB9z26okyNaFvh36Xlisn5g4B4aotyOo2QfHa2wgNj+n+VvfttoVB1xzbkAmbTIETtw4DR3KSQ6ePUXTw/BVf8HawDiItw/bwPxEgoVGRE6P1BFiu1gshJq0s8dM6L7cOQGvbgm/g0xNcGHDZiMn723sWnKIQMG6P5TDCHqjzA7tdacIq4MtP3xAK43Q6L3F2VdV4I4MYGVDtcrDspZcN3vmC5r/mYvexMQjMevs4mD3xTIRAXtnB7Y/hUMxIO623cnRL++BcbiRZ/LIh6ioNojGhBHFdF9aM8QiTmCM8Y/sWGM2cYpPc3Tdez/GDHOA6ubLgonqta54mCtiqastY1XXsyoRP8bNBTFabiB6/jo9JaF7y7OtCu9gCQ9F3bukFvNaVgYqIt2liXWLF4y07AM/YKAjmk02wuwBgS6C7dneUtVT0mtkg5/q3VzTaSzLD+BeDVYb7h1OkGuMyqkrZt9DCcbUF+wGdlHnogkary1mPet3LbVDzzzPfkMeOOFtC6zkbE+wCWlJbb3ZM51eqEubpMbkIXCGGDxIVjqdDyGnUQ99vdTs3C6f6euMm7dIYeqIROeJXo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 10:09:59AM -0500, Peter Xu wrote:
> Alex Mastro: thanks for the testing offered in v1, but since this series
> was rewritten, a re-test will be needed.  I hence didn't collect the T-b.
 
Thank Peter, LGTM.

Tested-by: Alex Mastro <amastro@fb.com>

$ cc -Og -Wall -Wextra test_vfio_map_dma.c -o test_vfio_map_dma
$ ./test_vfio_map_dma 0000:05:00.0 4 0x600000 0x800000000 0x100000000
opening 0000:05:00.0 via /dev/vfio/39
BAR 4: size=0x2000000000, offset=0x40000000000, flags=0x7
mmap'd BAR 4: offset=0x600000, size=0x800000000 -> vaddr=0x7fdac0600000
VFIO_IOMMU_MAP_DMA: vaddr=0x7fdac0600000, iova=0x100000000, size=0x800000000

$ sudo bpftrace -q -e 'fexit:vfio_pci_mmap_huge_fault { printf("order=%d, ret=0x%x\n", args.order, retval); }' 2>&1 > ~/dump
$ cat ~/dump | sort | uniq -c | sort -nr
    512 order=9, ret=0x100
     31 order=18, ret=0x100
      2
      1 order=18, ret=0x800

test_vfio_map_dma.c
---
#include <errno.h>
#include <fcntl.h>
#include <libgen.h>
#include <linux/limits.h>
#include <linux/types.h>
#include <linux/vfio.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>

#define ensure(cond)                                                             \
	do {                                                                     \
		if (!(cond)) {                                                   \
			fprintf(stderr,                                          \
				"%s:%d Condition failed: '%s' (errno=%d: %s)\n", \
				__FILE__, __LINE__, #cond, errno,                \
				strerror(errno));                                \
			exit(EXIT_FAILURE);                                      \
		}                                                                \
	} while (0)

static uint32_t group_for_bdf(const char *bdf)
{
	char path[PATH_MAX];
	char link[PATH_MAX];
	int ret;

	snprintf(path, sizeof(path), "/sys/bus/pci/devices/%s/iommu_group",
		 bdf);
	ret = readlink(path, link, sizeof(link));
	ensure(ret > 0);

	const char *filename = basename(link);
	ensure(filename);

	return strtoul(filename, NULL, 0);
}

int main(int argc, char **argv)
{
	int ret;

	if (argc != 6) {
		printf("usage: %s <vfio_bdf> <bar_idx> <bar_offset> <size> <iova>\n",
		       argv[0]);
		printf("example: %s 0000:05:00.0 2 0x20000 0x1000 0x100000\n",
		       argv[0]);
		return 1;
	}

	const char *bdf = argv[1];
	uint32_t bar_idx = strtoul(argv[2], NULL, 0);
	uint64_t bar_offs = strtoull(argv[3], NULL, 0);
	uint64_t size = strtoull(argv[4], NULL, 0);
	uint64_t iova = strtoull(argv[5], NULL, 0);

	uint32_t group_num = group_for_bdf(bdf);
	char group_path[PATH_MAX];
	snprintf(group_path, sizeof(group_path), "/dev/vfio/%u", group_num);

	int container_fd = open("/dev/vfio/vfio", O_RDWR);
	ensure(container_fd >= 0);

	printf("opening %s via %s\n", bdf, group_path);
	int group_fd = open(group_path, O_RDWR);
	ensure(group_fd >= 0);

	ret = ioctl(group_fd, VFIO_GROUP_SET_CONTAINER, &container_fd);
	ensure(!ret);

	ret = ioctl(container_fd, VFIO_SET_IOMMU, VFIO_TYPE1v2_IOMMU);
	ensure(!ret);

	int device_fd = ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
	ensure(device_fd >= 0);

	/* Get region info for the BAR */
	struct vfio_region_info region_info = {
		.argsz = sizeof(region_info),
		.index = bar_idx,
	};
	ret = ioctl(device_fd, VFIO_DEVICE_GET_REGION_INFO, &region_info);
	ensure(!ret);

	printf("BAR %u: size=0x%llx, offset=0x%llx, flags=0x%x\n", bar_idx,
	       region_info.size, region_info.offset, region_info.flags);

	ensure(region_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
	ensure(bar_offs + size <= region_info.size);

	/* mmap the BAR at the specified offset */
	void *bar_mmap = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED,
			      device_fd, region_info.offset + bar_offs);
	ensure(bar_mmap != MAP_FAILED);

	ret = madvise(bar_mmap, size, MADV_HUGEPAGE);
	ensure(!ret);

	printf("mmap'd BAR %u: offset=0x%lx, size=0x%lx -> vaddr=%p\n", bar_idx,
	       bar_offs, size, bar_mmap);

	/* Map the mmap'd address into IOMMU using VFIO_IOMMU_MAP_DMA */
	struct vfio_iommu_type1_dma_map dma_map = {
		.argsz = sizeof(dma_map),
		.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
		.vaddr = (uint64_t)bar_mmap,
		.iova = iova,
		.size = size,
	};

	printf("VFIO_IOMMU_MAP_DMA: vaddr=%p, iova=0x%llx, size=0x%lx\n",
	       bar_mmap, (unsigned long long)dma_map.iova, size);

	ret = ioctl(container_fd, VFIO_IOMMU_MAP_DMA, &dma_map);
	ensure(!ret);

	/* Cleanup */
	struct vfio_iommu_type1_dma_unmap dma_unmap = {
		.argsz = sizeof(dma_unmap),
		.iova = dma_map.iova,
		.size = size,
	};
	ret = ioctl(container_fd, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
	ensure(!ret);

	ret = munmap(bar_mmap, size);
	ensure(!ret);

	close(device_fd);
	close(group_fd);
	close(container_fd);

	return 0;
}

