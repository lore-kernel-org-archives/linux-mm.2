Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C2C109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481E46B00A1; Thu, 19 Mar 2026 14:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432EE6B058B; Thu, 19 Mar 2026 14:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321856B058C; Thu, 19 Mar 2026 14:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4E36B00A1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:41:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC5C31DE4E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:41:03 +0000 (UTC)
X-FDA: 84563679606.19.CC7A09C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14720140010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:41:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R7+6m4R8;
	spf=pass (imf23.hostedemail.com: domain of 3PEO8aQgKCAksjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PEO8aQgKCAksjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773945662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wj/eHDFDJECgbC1JujhfrNs1ie4hmcl+U/ekk8UfMck=;
	b=erCb9B8z8+EArqaQl9y72jF1g+CMENbl6rtl4RYX8kdUgypEn0uE2v+QsydspnIEPKuwMF
	84eBLj+OPKMc/6TSvVJ0edV8Swpps6H/zX2tIXHmysTMsMB5BrGRzh90n63jT0ILxVh9M9
	c8jJ8UG9QiRyolc4hMYHaTytG7kqvD0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R7+6m4R8;
	spf=pass (imf23.hostedemail.com: domain of 3PEO8aQgKCAksjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PEO8aQgKCAksjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773945662; a=rsa-sha256;
	cv=none;
	b=aiNMvxXT056tc1tchJ+KK7WMYCYvpEGJHOQql3p7jZJAqdpytF22tbazDzp6VQ7By65Jpi
	POEzx53sGH5B6PtKhM0JCqxkmw8V1aU8raPqj48j74RFRx9vw8y8zwixK+I7+57ehEfabV
	b3OUmu3s/Q2lkMo1jOL8frz41d2bXXU=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836abfc742so12468955e9.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773945660; x=1774550460; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wj/eHDFDJECgbC1JujhfrNs1ie4hmcl+U/ekk8UfMck=;
        b=R7+6m4R8MRHg9sz+SP83SVrh3lpAQiiMWhXllT/1f2tl+qENtSgcn7FVJtO5kwN2bv
         awGKLKfBAd1RB4tOlhlgmeiLNFOjiIJRc4S/RJwZjcHd0xY0K6WBe88LvsQ88NHP6Gms
         RxDTO1B10lB9gfQZ0yFxGyiZV8K4k4fVUQgM06i2jqNTUs5wt8Bz0y4BholfIsyveDeS
         FJvzLF05DosUqkNJwjalmnjbP3ZmnDISiLas156uhqp/IWCo6/fu4BaDkoWNuOJvDjO3
         rwqP4dhVUvcxPTVxhTx8L+fS0nTAJNVlttXZNiI+GfTGZEzkfkLJ78uweLwnYhXIkvAH
         2T7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773945660; x=1774550460;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wj/eHDFDJECgbC1JujhfrNs1ie4hmcl+U/ekk8UfMck=;
        b=ACy57MSNvT4b3Kbk2X5fcvfFNtlFJNA0n0XK5tHw897NCW6oj6W1ZfnRQB+x81IYO+
         /K9vA1M6qMsfcOhwufZBFZdO9tF8fDEEGP98bp9qQ6Qsqyb7P6XCaZXQQVX7B2etArMr
         s42DNcsI+48THpFoUCanmo7qrDwiNY/5SE/T8Qbrvb8uSazxBt4WqE0p8cqQnt3mYzt1
         zbIPMGDuFnrTU2Pj0t1oZvjFEjHii5Ax+AAOOfgaaQhjWOenuXOcHW+uR7DszFzjf7Rm
         THqsCPfE/dKc4fXCInCb+pVT9n5T9brCINNUXk7MQWB1ACFKpdFZ/fdcPllNJOj3EgtI
         ZYrw==
X-Forwarded-Encrypted: i=1; AJvYcCWFr0sAShAVQLhuIg1C3NxygcuHwA4fcP6eCLhCX9SElpzmrsEOE9QDHWqTHkCzlP0fxB/nOqAJAw==@kvack.org
X-Gm-Message-State: AOJu0YxTFGAfcHwijuxcMKzQWT0gGG1ZaRQxQHXV03OT/cVwmt6XO4tW
	HdnCmwONGNrNrjGCpMBzU8wrEZtUkHrh6E11rh1e8aH7CYpV9yajY1WeQFl/Jl4G+hCxSpLSk5j
	SqKMQwrO8ZHHuhA==
X-Received: from wmd25.prod.google.com ([2002:a05:600c:6059:b0:485:3925:a795])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b83:b0:486:fa9c:185 with SMTP id 5b1f17b1804b1-486fee2ffd5mr2113575e9.31.1773945660383;
 Thu, 19 Mar 2026 11:41:00 -0700 (PDT)
Date: Thu, 19 Mar 2026 18:40:59 +0000
In-Reply-To: <abwqq28hWXMLqa5P@casper.infradead.org>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com> <abwqq28hWXMLqa5P@casper.infradead.org>
X-Mailer: aerc 0.21.0
Message-ID: <DH6Z95PTZYVF.3K64RCJC06GEJ@google.com>
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
From: Brendan Jackman <jackmanb@google.com>
To: Matthew Wilcox <willy@infradead.org>, Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 14720140010
X-Rspamd-Server: rspam08
X-Stat-Signature: xtwu6toqbspgymkk6cii3m1wh9iwqijd
X-HE-Tag: 1773945661-37038
X-HE-Meta: U2FsdGVkX19vEbJLQOqjydyQ/VGU3voHPo/Ht2SaIXw9znwAss2cStf1Pmshx1L2d8cPHg1Iep9h6Jeb/cUckvkCBWxLMHW61Sv+nPfxLuoWKd+NOwDZDM5M28jWmCPX3A6XrgJN2tJpKyyMX1QgNpEpO8tViR4wIzMry+0LAOntSY1KOszCyUPVJSvvgwb6nNuZp4uUfN/Oz8ZMHkavg8xZJp6ILr1WOL1FChQtygOx2qSiPqykU6yAQbsbyh8JOLBIH6wYeyKN3Im7WlaPU9rDreF4oVAVvw/bRGfb4EP3wHwlUkU7RMSv82jv7vvQyaqx81UOu4cBJ1JJzthqC+VvHZT0TIV+pigycxtzGaT95xtVD8PhjSxAvWoG0UqxoPSwcc7dKTeOKml7irw+a2WpWW8bCtt4oxQtDoTRP+vKbi4yUNwWh8EC+kVCoIuOHzbgZQ97AX+NHT8C/zDD0UJEwh9erHGv3LOKQ/4WbE4GupOgWZcBNNsbWtd7r9+jY+572blndTXGYaENWiPUj6QUWK3XGHcMKv1So4h2zj0rSitoZbhejy5Ulag3X5E766VsT9sxuBzufN4foiAdFeDMk54wP+Z2KraEfDRu0GTlVdzx6iMUn+ATPiawTcROKspkBd1OVhDDQuVyFwiiz/qe8msbH4z7RrBQh6q65MlZMNrL1k/IXqUlMVsECmoT6Q95iZ4/qMqYK7nh6IRJOolbzBMMvbHWJTFaXOStDamyz+mBOCDQzeIkWiCwjEmaWxgrFW5IUUmItOJ38tpXKTQJGQQRtfBfHpl00Lxa7i0brlBZRLOj1B1tyjdI8+mTkMiNDuvb/B5CbVSHue8eyqxw7VKiVUQMKJhikrnFHP1eRm28/MzuvJhziCdW6f4T/AY+0vi6CiKZr3vpzZT34AuPd/0INRJPE7GHv0cdWZDrTUgEMNGW/fvpV+cKbN17m1gzNjsAnZsxS9NGB49
 kjojh8At
 m9lAxRbdMuYLH9g4hpFtukSY5soZt+1yADgbUegTBR2o8jmLAydE4TCHifi2p74U/XDKl1mkRqvhhu6DtoPitqaxLq4I64JQlLbmjBUnM9NpxsNcVzcwCUbYcidAkcmwVl5aOBRAMkkjJ/4A+gQJTI5VNR74e47oGHAvb7dHi28NWFe1Axbhua/MTyHgh3Y0SdC6JMzuvBQYuNwAF6a2f/2HQwWRFNobbKa7qgZskH35ABkggnr4to/JD/StHny+9+jOXDWnillw7BCz/+5qI1JP8ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Mar 19, 2026 at 4:56 PM UTC, Matthew Wilcox wrote:
> On Thu, Mar 19, 2026 at 04:03:23PM +0000, Brendan Jackman wrote:
>> As pointed out by Vlastimil in [0], my proposal for __GFP_UNMAPPED is
>> probably not needed for 32-bit. This offers a way out of the GFP flag
>> scarcity so in preparation for this, flip gfp_t to be 64-bit on 64-bit
>> machines, while leaving it 32-bit on 32-bit machines.
>
> Ugh.  This grows struct xarray:
>
> struct xarray {
>         spinlock_t      xa_lock;
> /* private: The rest of the data structure is not to be used directly. */
>         gfp_t           xa_flags;
>         void __rcu *    xa_head;
> };
>
> which grows a lot of key data structures.
>
> It would probably have been good for you to have run pahole before/after
> this change and diff the results.

I will paste the diff at the bottom. I _think_ all the problematic
expansions are downstream of struct xarray, but it's quite likely my
sense for problematic struct expansions is weak.

> Now, you're probably saying "But this makes no damn sense, why on earth
> is xa_flags of type gfp_t?"  And the short answer is "because the radix
> tree has a ridiculous API".  But you'll learn all about it with your
> new patch in this series which converts xa_flags from being gfp_t to a
> plain unsigned int ;-)

Hm... so Can We Just=E2=84=A2 turn:

#define radix_tree_root		xarray

... into ...=20

struct radix_tree_root {
	struct xarray xarray;
	gfp_t gfp;
};

...? Or do we actually need to find a way to keep the radix_tree_root
from growing too? If so, given that (IIUC?) the radix-tree API is soft
deprecated, I guess we can be pretty simple-minded about it and just
define a fixed set of the GFP flag values people use for this:

enum radix_tree_gfp {
	RADIX_TREE_GFP_KERNEL,
	...
	RADIX_TREE_GFP_KERNEL_NOWARN,
};

const gfp_t radix_tree_gfps[] =3D {
	[RADIX_TREE_GFP_KERNEL] =3D GFP_KERNEL,
	...
	[RADIX_TREE_GFP_KERNEL_NOWARN] =3D GFP_KERNEL | __GFP_NOWARN,
};

Would that make sense?

---

  struct acpi_device_bus_id |   +8
  struct address_space  |  +16
  struct amd_iommu_viommu        |  +16
  struct auxiliary_device   |   +8
  struct bdev_inode     |  +16
  struct blkcg          |   +8
  struct cgroup_subsys  |   +8
  struct chain_allocator |   +8
  struct compact_control |   +8
  struct debugfs_inode_info |  +16
  struct dma_device        |   +8
  struct dmar_domain    |   +8
  struct drm_conn_prop_enum_list |   +8
  struct drm_device      |  +32
  struct drm_file        |  +16
  struct drm_i915_file_private     |  +24
  struct drm_i915_gem_object       |  +24
  struct drm_i915_private          |  +40
  struct drm_master      |  +24
  struct drm_mode_config |  +24
  struct dw_dma         |   +8
  struct ethtool_netdev_state |   +8
  struct ext4_inode_info |  +16
  struct fsnotify_group             |   +8
  struct gendisk        |   +8
  struct hsu_dma        |   +8
  struct hugetlbfs_inode_info |  +16
  struct i915_gem_context          |   +8
  struct i915_gem_object_page_iter |   +8
  struct i915_perf                 |   +8
  struct ida               |   +8
  struct idr            |   +8
  struct ieee80211_if_nan     |   +8
  struct ieee80211_local      |   +8
  struct inet_connection_sock |  +16
  struct inet_sock            |  +16
  struct inode          |  +16
  struct inotify_group_private_data |   +8
  struct __intel_generic_device |  +32
  struct intel_gt                  |  +24
  struct intel_guc                 |  +24
  struct intel_iommu    |   +8
  struct intel_uc                  |  +24
  struct iommufd_viommu          |   +8
  struct iommu_group           |   +8
  struct ipc_ids        |   +8
  struct irq_domain           |   +8
  struct iso_inode_info |  +16
  struct kernfs_root    |   +8
  struct kmem_cache     |   +8
  struct kvm                  |  +32
  struct kvm_arch             |  +24
  struct kvm_mmu_memory_cache |   +8
  struct kvm_vcpu             |  +40
  struct kvm_vcpu_arch        |  +40
  struct loop_device             |   +8
  struct mei_aux_device            |   +8
  struct migration_target_control                               |   +8
  struct mqueue_inode_info |  +16
  struct msdos_inode_info |  +16
  struct msi_dev_domain        |   +8
  struct msi_device_data       |   +8
  struct net_devmem_dmabuf_binding |   +8
  struct netfs_inode    |  +16
  struct netlink_sock           |  +16
  struct nfs_inode         |  +16
  struct nfs_net        |   +8
  struct objpool_head |   +8
  struct oom_control     |   +8
  struct p9_client      |  +16
  struct partial_context             |   +8
  struct phy_link_topology    |   +8
  struct proc_inode     |  +16
  struct protection_domain       |   +8
  struct pts_fs_info     |   +8
  struct raw6_sock      |  +64
  struct regmap               |   +8
  struct rethook      |   +8
  struct rpc_inode      |  +16
  struct sctp_sock            |  +16
  struct serial_ctrl_device |   +8
  struct shmem_inode_info |  +16
  struct shrink_control |   +8
  struct snd_card       |  +16
  struct sock           |  +16
  struct swnode         |   +8
  struct tcf_block      |   +8
  struct tcf_idrinfo          |   +8
  struct tcf_net        |   +8
  struct tg3_dev_id           |   +4
  struct thermal_zone_device |   +8
  struct trace_event_raw_dma_alloc_class |   +8
  struct trace_event_raw_dma_alloc_sgt   |   +8
  struct tracefs_inode  |  +16
  struct ttm_bo_swapout_walk |   +8
  struct v9fs_inode     |  +16
  struct virtio_gpu_device |  +16
  struct virtio_pci_admin_vq                    |   +8
  struct virtio_pci_device                      |   +8
  struct vmap_block_queue    |   +8
  struct worker_pool       |   +8
  struct xarray         |   +8
  struct xhci_stream_info |   +8

