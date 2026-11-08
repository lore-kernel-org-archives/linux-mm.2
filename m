Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB6F606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLLG5k+V
Received: by kanga.kvack.org (Postfix)
	id 01D196B05D8; Sat,  7 Nov 2026 19:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38066B05D9; Sat,  7 Nov 2026 19:44:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74AA6B05DA; Sat,  7 Nov 2026 19:44:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3CD66B05D8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5923DA0413
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:39 +0000 (UTC)
X-FDA: 85410106278.03.8576D3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B9AAC140002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLLG5k+V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098677;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FjExzab0Z/hM4O7U69ttoJFEAdHA5oTfFDTRTjZy7k=;
	b=UoN8IcHg+bPw30l2ojmTgjEFPKd49YmVF0XbjubxbZBGjmtH3CqKtyDFcDYCdS9lmpqQC+
	TtpAcsKkGv2UUqtBZ8ftzylaQe1YfxpDk7DM3fk0D7gR6xrUL3RR5n1gehmQO+br+ggpWu
	lAoYFb43tphwgdv6hvcXNBjlvecp2XE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098677;
	b=EbU1EnHUupyD0rh5CTxTHHIYsmXr3euYG4XeZS5KnMl6poq5HISxmSF/R4yGox1T3B3Pri
	WIZOsnWvVrtyRsn7Cmxi3+ta0bMTBgqwJLuesevCCsaFSRzgiIy2z7xNHgfmDOh55ZTXLJ
	3eSQs4waAhNYg7hm/3+zxqDZAqNEs5Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLLG5k+V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 598B06129B;
	Sun,  8 Nov 2026 00:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262801F0089F;
	Sun,  8 Nov 2026 00:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098677;
	bh=0FjExzab0Z/hM4O7U69ttoJFEAdHA5oTfFDTRTjZy7k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oLLG5k+V9m5YUrEVXkSiiZDNoV3sy3GY4PGnHfdHwozpuBAq6Biz9qC9BkwjLyBb1
	 gr7byvzLiRK9VWpZNIg/6U97K7WGh13xHzFcKDRzO+ZnbSqB19hA4Z26+bsIHSVeS8
	 pgBw7lB5p/1oSejZJg0V/iGsf5xpbgAj5rDJGb9LPCRWzuM9xExnMOgNiXc3JqCz3S
	 kH94LNDx0jwZ3AeAUqKRumsuDJYVMvlwdQ793HDfew5MSIPMEhCJ7u/VJ6ARIc05Ta
	 O9NWxIwMeQvYFmlnDE+auEWajfRksxsvnA0zB4FnJ9sdkb2VmSqwrc226RpoW+BxEP
	 GG4TqOtjU4t7A==
Message-ID: <sashiko-outbox-203483@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 72/88] KVM: selftests: Add initial VFIO test
 verifying device info
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-72-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-72-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:35 +0000
X-Stat-Signature: e9o1rmiguh7sg99rymdb7c61dwpuau17
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B9AAC140002
X-HE-Tag: 1794098677-827976
X-HE-Meta: U2FsdGVkX18/Ni110HEIUbYugfjJVoIeG7QnpvqlT4WbPZIHKE7PUuXLND1ZKB69Dz3pQZo9Ox1kaRO2FU25WZLCWXA0J50H3Go7HhEWXBwMxAXKrB+gHIRRXoBgxhT08bW0p9jaOLhQj1GJrdo1gvDb7gKaxldNvYKghYPozCrck0JBl1pgJSU9Z4Nu9DGTYSf49GzAGQ/G53y5FYjQGEXUZwrzLUXqxxpjwrg0tjhl3FqExanKJjOFA+AyTDIA4oEGCcXFUMmPxEGJeQWbip8ul6H5yIzNYM75070cjCJAZqQBjRVNDz8ymlAwzEffdWYPyRJyJJ/EcCSUMwVXhTtMgtNT6rvBNp84tunc+YBqKgJMY+OhDzQ7Zyb8cOq6FTed9nb4mMYw3S5aQg9nHfWxYoXz81hxPnoVHohnUAZ+FwBY6p4yyOeFENK0jsoDIFeu9qTFyAB4yrgRM0gGjKYsT3Yi/O4cHoH9bAlz6baOHgViVEI3vRAesDkMMsnalIqoDaia5lrX0RvOVN2VacU3CBvu1Z7+nQ3sU8x8glqRGTgGjq+o6VGEu5tUF2IN8AH81Hs11xnLgl7rZSds3/HRoFnzIywtda9/4FulS2gW2Xk77xe9MwOMUnrQdWQRktEAudSx45iBd+OVHRyzDcDM6lXacE4YkJNxbsE9wKUK1mA7l5O0A/ylcO+OXEeE2j+jg562SSBVALc65zeZEY4cLj5zPXdxC4TF6JXHtbBLGHFVjtyLJAvOjosVzfKPZm1oBSuDHXtzK/IXvIDg6IEotSCxbmy8YU25NSTmXY2bl0KRUNS7q4QN0+OXcSXMssxihcy0t86FL4SPAyTXa4fHG7Bzo9z+2z0ptjHDO27t172IX62yM47hIcwzFnvCC5iO6cxpdg5mJcuk6wANkz8xad/IiV1k8xBNIemV/mks0t/rE189yud1aDWFBmm9Aq/IhTrz4YlK0Dxv810
 YfZH1+0Q
 1Ly4y0LH+xMOR5MXYXjeR1MQLixiPaBjXL2an4k+RjgiEByjn2R25VGUyPSPA+Emshg9ynk8AgYLMOl1gSoiYDL5o0EI8cbRL1KGG5Mvwz0C+DQqxExSltswPeQqZSJonN+o+Gs4koycdvQQ/jaOxxgoLtupIWD6ubzP+ynyLPvFAYCbQOoRkOOd/KIZlMWAizVGuryaQ6SB6/FfxSXDC6co/RMdcPjs2TV5ow8UQ28gPUZlY21JbetQiGqWExlO9zPKx2PcLpTnEvhmJ0C7Ltiq6shsZgkbK+whca0D+8vLp8F10whw3BIkA5Dl5V66ZdNRVDkD2wxwThXDByW+GXTouMAlZj7o5fizC7DIp3CjPXV12Lx9qxm2ADXvS2O24cwDoW8RBxZm/vqW4yiOYahUt0EZl1WVlcs9XJG6AQEuyLilVcy+BoCrQRI42otVotCIAaZEb2r5y5I3ThBN2PvQVplP//t7h2MbgG2E+DQszMpscchhuSoE/s/U81tmaHjHAZifu3VbHArRtQBYQ0vf1vkoJtv3l9j5DjWC0TBfgtRobM7ODOnNFrJbEhBHkldW30vFrEBQ1AFtFCZgAbNs4PlBwM/4GxyQYQBW7SjIaP+Zy5SPgFP1v3lp5rc4nR2Wn2bO80NnkhRQljjW9fH1bGoVe/ld304QV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: selftests: missing cdev availability check in
  find_igb_cdev_path()
--

commit f49eda30798c7be85f256d365f245ff1c80a3c8c
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Add initial VFIO test verifying device info

This commit adds a standalone KVM selftest that opens an Intel 82576
VFIO cdev, binds it to iommufd, and verifies the device information
returned by VFIO_DEVICE_GET_INFO.

> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/to=
ols/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
> new file mode 100644
> index 0000000000000..669acc6058b5b
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c

[ ... ]

> +static char *find_igb_cdev_path(void)
> +{

[ ... ]

> +		/* Found an Intel 82576 device. Check if bound to vfio-pci cdev. */
> +		snprintf(path, sizeof(path), "%s/%s/vfio-dev", sys_pci, dev_entry->d_n=
ame);
> +		vfio_dir =3D opendir(path);
> +		if (!vfio_dir)
> +			continue;
> +
> +		while ((vfio_entry =3D readdir(vfio_dir)) !=3D NULL) {
> +			if (strncmp(vfio_entry->d_name, "vfio", 4) =3D=3D 0) {
> +				snprintf(cdev_path, sizeof(cdev_path), "/dev/vfio/devices/%s",
> +					 vfio_entry->d_name);
> +				closedir(vfio_dir);
> +				closedir(dir);
> +				return strdup(cdev_path);
> +			}
> +		}
> +		closedir(vfio_dir);
> +	}
> +
> +	closedir(dir);
> +	return NULL;
> +}
> +
> +FIXTURE(guest_memfd_vfio) {
> +	char *cdev_path;
> +	int iommufd;
> +	int vfio_fd;
> +};
> +
> +FIXTURE_SETUP(guest_memfd_vfio)
> +{
> +	struct vfio_device_bind_iommufd bind_args =3D {};
> +	int ret;
> +
> +	self->cdev_path =3D find_igb_cdev_path();
> +	if (!self->cdev_path)
> +		SKIP(return, "Intel 82576 device bound to vfio not found\n");
> +
> +	self->iommufd =3D open("/dev/iommu", O_RDWR);
> +	if (self->iommufd < 0) {
> +		free(self->cdev_path);
> +		self->cdev_path =3D NULL;
> +		SKIP(return, "Failed to open /dev/iommu\n");
> +	}
> +
> +	self->vfio_fd =3D open(self->cdev_path, O_RDWR);
> +	ASSERT_GE(self->vfio_fd, 0);
> +
> +	bind_args.argsz =3D sizeof(bind_args);
> +	bind_args.iommufd =3D self->iommufd;
> +	ret =3D ioctl(self->vfio_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind_args);
> +	ASSERT_EQ(0, ret);
> +}

[Severity: Low]
Can FIXTURE_SETUP(guest_memfd_vfio) fail the test instead of skipping or
trying the next matching port when /dev/vfio/devices/vfioX is absent or
already in use?

vfio_init_device() registers the device under the vfio-dev sysfs class
even when CONFIG_VFIO_DEVICE_CDEV is disabled, so
/sys/bus/pci/devices/<bdf>/vfio-dev/vfioX exists without a corresponding
/dev/vfio/devices/vfioX node.  In addition, Intel 82576 is a multi-port
NIC, and find_igb_cdev_path() unconditionally returns the first function
it sees in sysfs, so if that port is already bound by another process or
if the cdev node is missing or inaccessible, the test fails on
ASSERT_GE() or ASSERT_EQ() instead of trying remaining ports or skipping.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D72

