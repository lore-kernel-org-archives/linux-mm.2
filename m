Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DC7606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AraWm00e
Received: by kanga.kvack.org (Postfix)
	id 96C196B05D1; Sat,  7 Nov 2026 19:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943F06B05D2; Sat,  7 Nov 2026 19:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880346B05D3; Sat,  7 Nov 2026 19:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA296B05D1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BE94C021B
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:32 +0000 (UTC)
X-FDA: 85410105984.12.B9CF06C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BE51EA0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AraWm00e;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098670;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53jOGcdJbwLaYFDK5Dh64G/hXGRygLL9dNirpw1N2ig=;
	b=kia18i/rZwBNVdsgWsvLRgeBNtlBWMF7Udk8N7p4ljiON2Xm6UF6Htp1ibL+7Dg1YQiaK8
	hDJlMXUlqpQfg4GGz6omJQVTLo3/XDPZ+8KRTJNNFw2FXkhA1b207rLt1CdPVpdW0flGtb
	yF9f4qVnV0La5C5sfP7TicfLXNE9QRU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098670;
	b=MggTviNq0wuVz3/p1foLbYT5g/EwQ8cOROCkW7qNU62p/DDQC/YaX01fKgNMl5BCGTpIdm
	/41m+jotr7kDXxiN28SZgs2aQ75B/YgqanBQVj/MOAF72Gl2oNZOyKIt2Ou+OkMH9+l40R
	j64GUXbitVodQbqzp7EIfPmjfV3SKOE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AraWm00e;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6041D6129B;
	Sun,  8 Nov 2026 00:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0CA1F008A4;
	Sun,  8 Nov 2026 00:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098670;
	bh=53jOGcdJbwLaYFDK5Dh64G/hXGRygLL9dNirpw1N2ig=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AraWm00eB9oFyPpMsM8m+NWCtLo8oJT8FInaPIGYHgp7ScgO5eBQYAysuQRxMjbQ5
	 EaVTqRgIOPi3g4I+1xm1TtDGdiW+xGudhM+NaovOAN/wwzgbvJDyaarioLNI+i1YhM
	 OtuR8I1geoc48G512UKAGtWVRTj+aUZ+kiVTdCswm4bLkhIgrfRi0f8UEP4myE3DF/
	 ZQ6a4r/Fo+lZJT4+jGSjNOWLwIlhUJ3Z74e90tod8S5rTyyS+SaRmewKlJHo4I0/UF
	 jd4as/iXE6vF5BklxlEHTieiT7AUV3v3IQnamJro7MmFbOK2l4NsyZGOoDoD2Fjy86
	 X7v6XEVg4S5Hg==
Message-ID: <sashiko-outbox-203475@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 64/88] vfio: Add vfio_device_gmem_revoke helper
 for guest_memfd
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-64-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-64-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:28 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: yb9td9o6y36wrjero6hywmhgo3h5781i
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BE51EA0002
X-Rspam-User: 
X-HE-Tag: 1794098670-788835
X-HE-Meta: U2FsdGVkX1+0hmtpnUaDpS9Eg12oASv7jJ6KBHo4vpkjDSgvcOUdUYc8G1R8HO6KB2yGJDY5y6dsBhn1A2XfTJF2B/nEQERWlnhjf/xpc42QqAnezGzYaMA1EcPKi96CA5hcCD1bQyIW27CPlIHhrtOSn3/18TgnXR8xNKV5fC8YWfKrEwj8s2OciY9+8F4pY3SnnXFnkbDWmzwf8k7B5nICVsYwUh4wrl93UzJQRDGjKCBnYrdQXvzSVYaU1vVG7kY90Pf5HUGzytt27u3zJJjTOuWLXpgBFa6Gj7ifQ6aYPN3cVOd7aL6bqJNzA/F9z/nj6FgfNxmwTciQ6a91OyE9ftIpLwLoFzK7KMMWJM0lyDyoXlwK7UTWSPDNvA1IYdpIDb0Lj6GFebYeasaIp1FMcm40utLApfpdrbOpZ8QMiZuPC2/2SKpXSwGLkT1B3gMSd8E7yCRZg+NtNnIWHRdkfwo4P8ceRH/IVIXfRnmRPD3KhobLYpkKN5mrIS6mFKh7PUv8Gd5Lw+GPRJ7m0SV7zWS1XYeV8CWqL2FJepRTOeHS06/OVPOs3Akug0Ac26GPrbMvAEQNCCWGvnJpNKg9T8nti+aPFHSIyh/AwNhcUUnK46PSbxsuBEVQKw1Koy5ZWaEMOvOLD8k9wHRr+CDo82aps42dTTeKhE2lJ0g6KbNmxUx66eOvYW2mwKRBQQW7BVlvLgFvoT92GGV5ieY1LqHHuJjtlLC9EFoJ0q+ZN66TBE1qMjzZDBCuIPeMVk4VP508wHH1s0KwHUqvIF8uYDNkr6YOMlWQyZB0YR7vxC3pq5W8vLIOT30dTw+lgEam/br8bcFJWufn8uH0rmwJOFbYy227cvpU3ZtrrRF/1UkyW0SDDOwQXnzWFpg+MpRVZ1ok+8COtjkePGuy99ym8qLaT7GQeeUSLB8TUce4UwhCMikmYSncxaODL6yQS5eVO9ei63WzPyeI7J1
 qq40BYPv
 QR2fwJ23w9poDFaKvunGp3jacp0aHDQgQHggonuKBQqmfMjLB3ue8/4hxDdVrZqry0zm7znfUTAQgcnxn0kiIoTqVcCQ1wk6ii8wlcJMt0LoGb00X05FQ7L0b68aYU2PDPNM6BqxCWnMZBFYZxudb3qSC0eEz4oXrF9KgitUOFV6jtN2DDbOGXJrVAVqgfpkyGiDo/7EB6usaYgHib2mopd5noMjgsVd2pUQvkxQHXwEzc5rhq5KWi/K7GJfeU2ebS1mLscepldza/LGEAUActVGIpSiaIxrX6yIuRV+JLYhdFhaGICuYeR7yI6BJBVAYbGIabakeWwJR0ZN2qZvMC6PO/gUXkPQKpLaWEi4twrxZWMgixMygYajaJ1HRlxgroPU0vLN3+Yt0rjQDY2S3DADHgjfuYj5A5ErCsy5lqqyXtEu1xxTNfYrM8xmaFpulkP+BUFSXHKDkmVy6mFJiYjVVcV95YvTOAdaKNk8+KNH5cO7cbqCZVS312p2hmLF1UdVeWYTTq3A5PecYChgikNy4Xnpse8EWEMR1FXOZ5JILEiNqdws5/fLhGgeZKg2saAohKRk4IjgX294VV+EdeXTzbWyOdNElFszveDY1z7T5ikJBUODhSWa9pvAVeQdMstGMM4eg7r3L/pABcCOTZJB4GFY6lt1IO3UoLKPRKbQARxqgl9Fvv1XKro1+2l7/QEHPSgEl6W8McHAaxY0d8JpQVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] vfio: link failure in vfio_device_gmem_revoke() with
  CONFIG_VFIO=3Dy, KVM=3Dm
- [High] vfio: unsynchronized gmem_inode access in
  vfio_device_gmem_revoke()
- [Low] vfio: return 0 in !CONFIG_KVM_GUEST_MEMFD
  vfio_device_gmem_revoke() stub
--

commit 64f7b4c8e914dff002926c09d51e57c7fda9c500
Author: Ackerley Tng <ackerleytng@google.com>

vfio: Add vfio_device_gmem_revoke helper for guest_memfd

This commit adds vfio_device_gmem_revoke() so VFIO bus drivers can revoke
and reclaim device memory ranges from an attached guest_memfd instance.

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index e4e7bfe77d03b..fd5f71dfc44b7 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1643,6 +1643,16 @@ static const struct guest_memfd_provider_operation=
s vfio_device_gmem_provider_op
>  	.mmap                 =3D vfio_device_gmem_mmap,
>  	.check_set_attributes =3D vfio_device_gmem_check_set_attributes,
>  };
> +
> +int vfio_device_gmem_revoke(struct vfio_device *device, pgoff_t start,
> +			    size_t nr_pages, const unsigned long *pfn)
> +{
> +	if (!device->gmem_inode)
> +		return 0;
> +
> +	return kvm_gmem_revoke(device->gmem_inode, start, nr_pages, pfn);
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_gmem_revoke);
>  #endif

[Severity: High]
Does calling kvm_gmem_revoke() from drivers/vfio/vfio_main.c break linking
vmlinux when CONFIG_VFIO=3Dy and CONFIG_KVM=3Dm?

CONFIG_KVM_GUEST_MEMFD is a bool selected by CONFIG_KVM_X86 on x86_64 even
when CONFIG_KVM=3Dm, which links virt/kvm/guest_memfd.o into kvm.ko while
vfio_main.o is built into vmlinux.  With CONFIG_VFIO=3Dm and CONFIG_KVM=3Dm=
, the
direct symbol reference also forces vfio.ko to depend on kvm.ko even when
VFIO is used without KVM.

[Severity: High]
Can vfio_device_gmem_revoke() race with vfio_device_gmem_release() and
cause a use-after-free or NULL pointer dereference on device->gmem_inode?

device->gmem_inode is set and cleared under device->dev_set->lock, outside
the bus driver's lock (such as vdev->memory_lock), while bus driver
revocation paths call vfio_device_gmem_revoke() without holding
device->dev_set->lock or pinning the inode:

CPU0                                  CPU1
kvm_gmem_destroy_inode()
  vfio_device_gmem_release()
    mutex_lock(&dev_set->lock)
    ops->gmem_release(device)
      down_write(&vdev->memory_lock)
      ...
      up_write(&vdev->memory_lock)
                                      vfio_pci_zap_bars()
                                        vfio_device_gmem_revoke()
                                          if (!device->gmem_inode)
    device->gmem_inode =3D NULL;
    mutex_unlock(&dev_set->lock)
  ...
  kvm_gmem_free_inode()
                                          kvm_gmem_revoke(device->gmem_inod=
e,
                                                          ...)
                                            <-- use-after-free / NULL deref

Because device->gmem_inode is read twice without READ_ONCE(), clearing it
on CPU0 can also cause CPU1 to reload NULL as the inode argument to
kvm_gmem_revoke().  Similarly, in vfio_device_gmem_attach(),
ops->gmem_attach() finishes before device->gmem_inode is assigned, leaving
a window where a concurrent vfio_device_gmem_revoke() sees NULL and skips
revocation.

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ffb01e655735f..aade091a91fe8 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -394,6 +394,18 @@ bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
>  void vfio_file_set_kvm(struct file *vfio_file, struct file *kvm);
> =20
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +int vfio_device_gmem_revoke(struct vfio_device *device, pgoff_t start,
> +			    size_t nr_pages, const unsigned long *pfn);
> +#else
> +static inline int vfio_device_gmem_revoke(struct vfio_device *device,
> +					  pgoff_t start, size_t nr_pages,
> +					  const unsigned long *pfn)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif

[Severity: Low]
Should the !CONFIG_KVM_GUEST_MEMFD stub for vfio_device_gmem_revoke()
return 0 instead of -EOPNOTSUPP?

When CONFIG_KVM_GUEST_MEMFD is enabled and no guest_memfd is attached to
the device (!device->gmem_inode), vfio_device_gmem_revoke() is a no-op and
returns 0.  Returning -EOPNOTSUPP when CONFIG_KVM_GUEST_MEMFD is disabled
makes callers that check the return value fail even though no guest_memfd
can be attached.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D64

