Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E863CCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 00:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554EC8E00B8; Mon,  3 Nov 2025 19:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BEF8E0058; Mon,  3 Nov 2025 19:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442508E00B8; Mon,  3 Nov 2025 19:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30BF88E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:06:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB1E213A93E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:06:23 +0000 (UTC)
X-FDA: 84070982646.25.987DE26
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0076B4000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:06:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=TcTJIhK9;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.52 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762214782; a=rsa-sha256;
	cv=none;
	b=DW+PgF48iObZfYXFAeQOxfq9N/5w2SCV+tTCAWQXPwcFBlm2FKd/sNc5UiO8+1kNxwFYS9
	inaTxlgP8RmPuZgMcRFRlXH0ikewlyKG8YyPvCm77J9Eri/WZx/U/snKPsXEv+OAvv3cZQ
	QsYWmvHJU2us70Qdsjsuf4wmW+0M+Ao=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=TcTJIhK9;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.52 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762214782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7OiTJylN5oi1hTg8WqhFTipXs7uLO/TT2JZJ2yqlyQ=;
	b=zPFMVNQF8588U431n58tZQYNcIgx/mnjs5lsdxARnHmNIzM7v4UChNM8CQReW6/utctbmG
	k6i2PU/8uNyWOn//diJ/C/D5y73G95BPmvtqDyIES7ctqZ6o12JfNgc/OnPafkfUsAZjFT
	PylBGbxTAV0WifTq9MgBJ5atEjhQbJA=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7ea50f94045so58856806d6.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 16:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762214781; x=1762819581; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7OiTJylN5oi1hTg8WqhFTipXs7uLO/TT2JZJ2yqlyQ=;
        b=TcTJIhK9SXFoQ6WSML57krrhlGL4gAr96WCrX1puw0j9t8PxrwAH21Njq5WOPH2SYw
         zma9M7cMSsEBX5IbVjF8tC3ztRqTv2N6UTvIk4FyYLcYFJUZeEkIPX46Nv80AnBWolRW
         MI9KBcQsE6nnQYAWbCjd035dOqvR1TMbk0UwnzViKad4raanqofiEUijuUo7O46ara8S
         eLDAxJ27IClXs1rURY9hOjDJsL6bjJBRRk+QRc9jWv/uzz6Zul+o9hvLKLIUvsZeg4OF
         EJPfeCZvwrM5dqcpE/wtLkMHFogT9CdNkjix6V7yFpFe4MjM1rZinT9gUeYrvYfI5WCs
         bYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762214781; x=1762819581;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7OiTJylN5oi1hTg8WqhFTipXs7uLO/TT2JZJ2yqlyQ=;
        b=To4fmHXpUkeMAFLw2H634BaS3W/v8jNjBVlVOnvbbhRDcg8lYYBKYRE+zRqqnAEu4C
         Ac2j4kYht0j1Lg+AU8FX9fPAuahgHhfp1HFd4958dA0ZBbqMSGp6ELSV1OeX8ql9u4AJ
         3mhe7kD5r/cIeVuBDPgjTbGZ7RgM1zbsbpep69gD+UTyRTJ0v8BrMK7uo7prIzdHfIHl
         t8VvXhWeZBLuUNV+HYicV5uRFtDWkIMqStvnF/8/V7vUsxKotIw5T+aPKCcgDJ1oB7oZ
         jdN4jECqz0M67asl4xyYFf9PzCBuvpJlv55Fa3t0iVdLzhvk3/jj4sNjje6e67chXyzU
         h+9g==
X-Forwarded-Encrypted: i=1; AJvYcCXCqx+SjizRIQ1O7vgaPFLHiXuhxUUExQQDJjSmONhnSnEpBIhJ190cX0BOgUIy2A8qTJP6hLzWeA==@kvack.org
X-Gm-Message-State: AOJu0YyCKI2VN00Iy8k8nW0Tiwe/UP0R/KC1Z64a7/FepaHESg1e4ebh
	Ofogj7RE/fCPaP+OeYe0cKj3AuTOM/lVqH/JXP8Q82yPIiZcSODRvWQZDvxYIYnjtPA=
X-Gm-Gg: ASbGnctvI2LfNy2kr+/0DGeWuIiaJm+ekjfFi6FzMEfmXw6fCV99dXwCAbq4OqyDZyP
	6+OGyJ20v4kqF9662bUOaYWgDHnCzzqWswqHuKeq029ywp4S+Qf72AFDAP2Vnr63kgvyF8gdRRH
	+u7noBUjrVdzS+9jdUt2hfLOVMLTkEF8MnhIPmUXuLzMdUgml8VLYE/Zjk4peaq5qVnz8t7bz1a
	3Ig0WvDyL2gol+7U6Gm3mCqFSH3mHK5h+umvMkWsXxNTDiBYDPb/YQCotaLqdS9D3VvKWsEZNwA
	mm6s5A1eUXrndg0M7K0OInRMb7on77B+vOZN6s6z+mpF9n4soztyGfftm7h943Xqd/8K9PBOd9u
	eVkGhqeduBjly8LbdJraF/fmVxuBejbH2CEhXyhVb/IMwSw3xyPz7p6qlVYwVizV6kbo4DB5aVN
	AZrlY8kjs7MT9iP1P1Gq39Mzddvj2Lzv38VJvBzdp4fIpI/bAHQbuS7Ex6
X-Google-Smtp-Source: AGHT+IHFK/K4+Si4Ey1hcSvTZvkQdBHi3cl9Mtxmbm7oCurYD+QrPfezppoNLd/K4DVB+Xp/dYAQ0Q==
X-Received: by 2002:a05:6214:f22:b0:87c:270b:aadb with SMTP id 6a1803df08f44-880623a4a0emr16632746d6.16.1762214780972;
        Mon, 03 Nov 2025 16:06:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88060de9b44sm10817116d6.20.2025.11.03.16.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 16:06:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vG4Z1-00000006cRs-0csK;
	Mon, 03 Nov 2025 20:06:19 -0400
Date: Mon, 3 Nov 2025 20:06:19 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251104000619.GG1204670@ziepe.ca>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <aQkLcAxEn4qmF3c4@devgpu015.cco6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQkLcAxEn4qmF3c4@devgpu015.cco6.facebook.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0076B4000C
X-Stat-Signature: nacf75adzgk6yunqfxszoxt1a53gnbdp
X-Rspam-User: 
X-HE-Tag: 1762214781-293029
X-HE-Meta: U2FsdGVkX19bZ6xPGSoO8Be02NVqGHxVg0UxDeSp6WeKy0LRGTTzpyjvMtfsluTmMstnQX6q6TBmnJt2WZ4IZnB98oPlbjdJdRDort0yadJf9MwmjV0AJRzkvtZfp+gOSbRN+851Js1HzG3B906rjmVJjqY66f6u9GWvRUKS9P8A6tF3z0nbg2mn8u0ablX4pPMegSbQ/rNPWZ3E21Rucgr+fVu6GyEx1lju1C2F7rVRtWV8izxpaFlQyHAV0SBt2n2SQHQ5vGwNT3Yq8DttieE24ZsHhgkQXughdAgTwpBtTY9LT87AaV5ztt5uk+x7omTZo8gPGPK2OL+1d5X6G9jENkoqL07DaRtd9/XQmp1Jum58/hG/5ggQlsy+pMRUcEiUqAeBI+dvXH1nrlltYijkv971CTLOOCxD+pi5CJaqgtVbZibcLyalenWXd2/hWCelfbQqNdIUYRWgBoRwGcicy2L/L8L70UfgTseho8fX8oUmVUxmsdTXmLJf1jhhAmm66QR31wnPHEFGES1vdfIKYxx/qCKZsic0DlnuSwQXrwuzdtpFpl2xwa7PvKw0ocXWAm/jqnO7fhP55op3oPG6pT121MGjE2fS5er84e7dy23n/ogyrHg2GqxfBP0kdd7h8FalCvLxx505PbX3QPnq3BMvVg/9Lfmn/T3bGLFgA57WiYRBWNOuQ5YhdGSGM4XVG7nUnmTT6iBVGT5/ckdWmDglGlxb/M7vAJNI/nOZH3OxEvsK2G3jYLZMkXXkxz9RaC70//QiEyGg6mA+mEdXt/qYw/YxUvlPRoVnoa8XKIuQYybZQqnzJC/erRBtUQQR7Vt4IDGxQP2jEoeH8EBeQ5GR7I/OEtWO35ZRNzWz/J13P83s0fpTA1l1cRb+dEPtBzwAhj+jjUw6Sdsev7Xq5xMBmTEnL3xXAJJBhcrSGmHpE7xDcPcCErnXazhmO9z4ypTA8OpXZIx7at2
 ma+XMA6o
 c6N1aBcqe+QD3k6oBkFsX7BF0mqEItlDCFzNneQF0zrI8U4fHZgCzVCwlM8JWuhqYeUlhNTUg7fqRZ3xquSg+AD0Gds5Yfym7tfXGoG/a7UXLR4q7dvASZC/nsMFxfRApTOF96060j8L7QhWyJ9BrrvCWuLhcZSGVka9hzLIHoITj/xggOQYi4s9T3ISPNiCne24DkfEzAfrb2sCntPbnYYQws79oXwriqKfVdMEuZQF28jQzAQzv0wybh6dON7BxLZLZhrxybBLKK0U7Sgf6QQHi4eCnUrRBhLkb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 12:07:12PM -0800, Alex Mastro wrote:
> On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:
> > Changelog:
> > v6:
> >  * Fixed wrong error check from pcim_p2pdma_init().
> >  * Documented pcim_p2pdma_provider() function.
> >  * Improved commit messages.
> >  * Added VFIO DMA-BUF selftest.
> >  * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
> >  * Fixed error unwind when dma_buf_fd() fails.
> >  * Document latest changes to p2pmem.
> >  * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
> >  * Moved DMA mapping logic to DMA-BUF.
> >  * Removed types patch to avoid dependencies between subsystems.
> >  * Moved vfio_pci_dma_buf_move() in err_undo block.
> >  * Added nvgrace patch.
> 
> Thanks Leon. Attaching a toy program which sanity tests the dma-buf export UAPI
> by feeding the allocated dma-buf into an dma-buf importer (libibverbs + CX-7).

Oh! Here is my toy program to do the same with iommufd as the importer:

#define _GNU_SOURCE
#define __user
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include "include/uapi/linux/vfio.h"
#include "include/uapi/linux/iommufd.h"
#include <string.h>
#include <sys/mman.h>
#include <errno.h>

int main(int argc, const char *argv[])
{
	int vfio_dev_fd, iommufd_fd, ret;

	// Open the per-device VFIO file (e.g., /dev/vfio/devices/vfio3)
	vfio_dev_fd = open("/dev/vfio/devices/vfio0", O_RDWR);
	if (vfio_dev_fd < 0) {
		perror("Failed to open VFIO per-device file");
		return 1;
	}

	// Open /dev/iommu for iommufd
	iommufd_fd = open("/dev/iommu", O_RDWR);
	if (iommufd_fd < 0) {
		perror("Failed to open /dev/iommu");
		close(vfio_dev_fd);
		return 1;
	}

	// Bind device FD to iommufd
	struct vfio_device_bind_iommufd bind = {
		.argsz = sizeof(bind),
		.flags = 0,
		.iommufd = iommufd_fd,
	};
	ret = ioctl(vfio_dev_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind);
	if (ret < 0) {
		perror("VFIO_DEVICE_BIND_IOMMUFD failed");
		close(vfio_dev_fd);
		close(iommufd_fd);
		return 1;
	}

	// Allocate an IOAS (I/O address space)
	struct iommu_ioas_alloc alloc_data = {
		.size = sizeof(alloc_data),
		.flags = 0,
	};
	ret = ioctl(iommufd_fd, IOMMU_IOAS_ALLOC, &alloc_data);
	if (ret < 0) {
		perror("IOMMU_IOAS_ALLOC failed");
		close(vfio_dev_fd);
		close(iommufd_fd);
		return 1;
	}

	// Attach the device to the IOAS
	struct vfio_device_attach_iommufd_pt attach_data = {
		.argsz = sizeof(attach_data),
		.flags = 0,
		.pt_id = alloc_data.out_ioas_id,
	};
	ret = ioctl(vfio_dev_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data);
	if (ret < 0) {
		perror("VFIO_DEVICE_ATTACH_IOMMUFD_PT failed");
		close(vfio_dev_fd);
		close(iommufd_fd);
		return 1;
	}

#if 0
	int mapfd = memfd_create("test", MFD_CLOEXEC);
	if (mapfd == -1) {
		perror("memfd_create failed");
		return 1;
	}
	ftruncate(mapfd, 4096);
#else
	struct dmabuf_arg {
		struct vfio_device_feature hdr;
		struct vfio_device_feature_dma_buf dma_buf;
		struct vfio_region_dma_range range;
	} dma_buf_feature = {
		.hdr = { .argsz = sizeof(dma_buf_feature),
			 .flags = VFIO_DEVICE_FEATURE_GET |
				  VFIO_DEVICE_FEATURE_DMA_BUF },
		.dma_buf = { .region_index = VFIO_PCI_BAR0_REGION_INDEX,
			     .open_flags = O_CLOEXEC,
			     .nr_ranges = 1 },
		.range = { .length = 4096 },
	};
	ret = ioctl(vfio_dev_fd, VFIO_DEVICE_FEATURE, &dma_buf_feature);
	if (ret < 0) {
		perror("VFIO_DEVICE_FEATURE_GET failed");
		return 1;
	}
	int mapfd = ret;
#endif

	struct iommu_ioas_map_file map_file = {
		.size = sizeof(map_file),
		.flags = IOMMU_IOAS_MAP_WRITEABLE | IOMMU_IOAS_MAP_READABLE,
		.ioas_id = alloc_data.out_ioas_id,
		.fd = mapfd,
		.start = 0,
		.length = 4096,
	};
	ret = ioctl(iommufd_fd, IOMMU_IOAS_MAP_FILE, &map_file);
	if (ret < 0) {
		perror("IOMMU_IOAS_MAP_FILE failed");
		return 1;
	}

	printf("Successfully attached device to IOAS ID: %u\n",
	       alloc_data.out_ioas_id);

	close(vfio_dev_fd);
	close(iommufd_fd);

	return 0;
}

