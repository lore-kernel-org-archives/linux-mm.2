Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDF2CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAF46B0005; Wed, 20 May 2026 09:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BE26B0088; Wed, 20 May 2026 09:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B22D6B008A; Wed, 20 May 2026 09:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2915E6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:11:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00CD01A030E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:11:37 +0000 (UTC)
X-FDA: 84787835076.15.70ACBD3
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf18.hostedemail.com (Postfix) with ESMTP id 148EA1C0007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:11:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=i5FoT1Et;
	spf=pass (imf18.hostedemail.com: domain of igor.torrente@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=igor.torrente@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779282696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjZN7baVUkp//dQnaQw24mVQpih2pOULAojZG2gp0Fo=;
	b=ZlaWwy0nBAvV066En5Xpjs/UlOHpYKljQ6myVsjthpIPYwKxTQA+WId/dcLCgXfw4m8Xoj
	CQ4yJ/6I6oEwH4H+JUd1x/gBNEzncq7z+mh4YOaZn9HKbOcIuEccTL8OKtUluAsVgjbGzv
	l/F+JH01h90QPo/YL5L2o2Nw0N4RL44=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779282696; a=rsa-sha256;
	cv=pass;
	b=My5UUdw4JJ6nHnZmrTXQrHElrtUzLGCPMlE6nh98MbWb9mtMDI7i0kYfK28W5w0Re13RcM
	SlduqBzJlZwGvV3Cl9JoBO0cYvEzHFGzGZX9dytzf0KvF+z8sxxPc1fzrQZupyMU5fLt82
	KAJ2F2/UlsGN6B+N6S1VftIRFzcukjI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=i5FoT1Et;
	spf=pass (imf18.hostedemail.com: domain of igor.torrente@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=igor.torrente@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1779282670; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=h1A6Ce2M6EN2kc7ddYgHZvZ2kV4zvuk6c/Ej30YjJ05XfA2ra8yAD1svBWSpkgNES50zZiOTcxIHucqcnHbdqOtzSEhKIrjNi1Qw73uf75kjB0/8TgmVoEDUNPjRTq2fBDh1E1zEUrkF6pdX+bNagWn3xq/AG1BWmRAueV+HpbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779282670; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=IjZN7baVUkp//dQnaQw24mVQpih2pOULAojZG2gp0Fo=; 
	b=SMKa67Ad+M3ejKVjzlB07Vr/dXAotzopnF9aGNKocu3HKCu0snvb37fjKDVsy/bPhE9TQDwNzlkp/Koag6wpfQhbR/66o5TmFlEPCMPvn7y2Kt50/OT4YMep9Y/4WMNbCnFbndwJ5kiCdnZz9THt0joTGFXfCLrkEtLzfJTl5fQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=igor.torrente@collabora.com;
	dmarc=pass header.from=<igor.torrente@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779282670;
	s=zohomail; d=collabora.com; i=igor.torrente@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=IjZN7baVUkp//dQnaQw24mVQpih2pOULAojZG2gp0Fo=;
	b=i5FoT1EtPfvjXFHCzphk8xuo3GfMtbtQml9yUO5aavwMBi3GrPmaEjF/FABRc3W/
	UTR0EALQxg9Z5AqbPJZn5D3I+1fyuDbxhIci36XKxAKehOaR61EpzUoacy3jlp8wq+9
	u4pyqovSgJ9/Z2Me/fm85JwHN6laJMSaNTiQA7Co=
Received: by mx.zohomail.com with SMTPS id 1779282668370237.5626986578659;
	Wed, 20 May 2026 06:11:08 -0700 (PDT)
Message-ID: <d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
Date: Wed, 20 May 2026 10:11:03 -0300
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Thomas Zimmermann <tzimmermann@suse.de>, boris.brezillon@collabora.com,
 loic.molinari@collabora.com, willy@infradead.org, frank.binns@imgtec.com,
 matt.coster@imgtec.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@gmail.com, simona@ffwll.ch
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260209133241.238813-1-tzimmermann@suse.de>
 <20260209133241.238813-6-tzimmermann@suse.de>
Content-Language: en-US
From: Igor Torrente <igor.torrente@collabora.com>
In-Reply-To: <20260209133241.238813-6-tzimmermann@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 148EA1C0007
X-Rspam-User: 
X-Stat-Signature: 7k6qj9ngk7x7qbz6yq8qm9zdmpr19jaq
X-HE-Tag: 1779282695-989611
X-HE-Meta: U2FsdGVkX18J6yr/39WVC5fSS5l48pLi/MyJqRn8CYHhIyZOAz8pg5KizFX/pATKruxxqehqr8UrEyuuIo+d6fo/qO0f1gGpwy277Bb+0gs/NyxoyX1HqwjVbxTmyomxwyoO1c5FhSi07EINa/+kIrFQRQJl5Jhd7Lu3qSPxf9emiSAdNG5sdAM87SpLu08R9RxJlTKWdrrs5Ww1o22ELdRrlz22XpANIes5WjMn/HX4ZXefttezmkhMUowFphC2EVAPx1xLcSEd/EcGD+krOiPDXo9U6/ZFuol8TgOzNyyye3FAJbEwV0kAvat5ygKUTdjYOym4IYowzVoHYCdUy25JqY9tjtvR9jTUKZC7LhyqdfDMA+/1ISCvZneaophbdfH46EgxOq94zqnRAA7BmBAzmJ9isfkstF38jLnTIxcussdMeIzo1yXBsPW3fbiKwMSBuXWDiB3G3QnmFHf/GLAXrAUfMA8TDsOCecHD/77wNFh3QYuVd8F6noL3QrOWjHrFgslt83NZhBTIb9qzT0p1CFquvk2Zd8r3mbVRgZFkBriab8IO48xUvijaYFXpPhe7lnzNxXV96b/jMo/may+ZPYzzphTN0Wvh7+j6/DIf+CALjNR69XvoORhydfsBoXWrYCimtxI3K+ENyiXSz7I4yqny/VMYRqF1yqoET1W2Sw3q9+S6jaWmx06Fe9bXQVoZgqqJ/TVLEq41AvoeXwzrXOPhuaDc3xbG9aSuB+/bJsn/gG3sASsx3lCNTl2YEB9Lg3fUjxFDImJiDhJkqpnF5z14Dremf6pbKdMq3/BdIJhdMnvykIug4Xow61luxnhdxFjoTtP0zZMmlZJiGy4cETsZ0c7TtBCPQE83r77Q7rAzDwwJlZGRVjoMQuq5/caxGjhVzjjd7wTOBjywPehweC9xz6YzlJa6I7gVJcJ/EdnK8yNEJ/B+2JIKmGmeG5PYHxIa6ZOqBW5i7XZ
 6ad9Ujg7
 ZAXHvXexmJlU2APweV4fwTj5kYQZ2kcRIyYJ+xq/nCCZjk0lCSGNm4jiy8P+X7ax0CpBLu6dEB3KcSEYXq8cefP2DjXqtBgQiBGqjhsCObDdUNkdfzfAvz3GRzRO4xT0fgIAAsB9VvogOvkygB4mBx5WkC8N83zq9OAjEO4ok6losKwmcsPvWrBxT8/LzosRkfU5vrrwFZvkbnPXByc+oDusSBU7Hl4l+R79UPC1P33iLNy0LGYlykbLTqtEr1jYDrD0qPNGEysRfGMr5iQj3h6H/VmhshwkNA+RKPwsQ2vxk5EQlHHbN8TWPf3wjBes3NWaxFCrOpsw/eiA492V85ToPX3br5dLEYVQKog1k1bW82FVfoOvGPwLziuBMs2e7R3shhPBQKhjlium3p1kYLERJpo6Zf/ujZoizUV2LiWBkrRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 10:27, Thomas Zimmermann wrote:
> Invoke folio_mark_accessed() in mmap page faults to add the folio to
> the memory manager's LRU list. Userspace invokes mmap to get the memory
> for software rendering. Compositors do the same when creating the final
> on-screen image, so keeping the pages in LRU makes sense. Avoids paging
> out graphics buffers when under memory pressure.
>
> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
> for writeback should the underlying file be paged out from system memory.
> This rarely happens in practice, yet it would corrupt the buffer content.
>
> This has little effect on a system's hardware-accelerated rendering, which
> only mmaps for an initial setup of textures, meshes, shaders, etc.
>
> v3:
> - rewrite for VM_PFNMAP
> v2:
> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Hi Thomas,

I have and Radxa ROCK 5B+ with Mali-G610 GPU and I'm developing the VDRM 
(native context) driver
for panthor.ko.

Recently I update my kernel from 7.0 to the 7.1-rc3, and qemu started 
freezing with KVM error below
when running any graphical application with Venus or Panthor VDRM. For 
some reason Virgl is not affected.

```
error: kvm run failed Bad address
PC=0000ffffb4a86d70 X00=0000ffffb4be5000 X01=0000ffffb2279bb0
X02=0000000000000600 X03=0000ffffb4be5000 X04=0000ffffb227a1b0
X05=0000ffffb4be5600 X06=0000000000000001 X07=0000aaaaf384fd80
X08=dcc58d0daf897753 X09=0000000000000002 X10=0000ffffb4b96758
X11=000000002533f84b X12=0000000000001060 X13=0000000000000000
X14=0000000000000000 X15=0000000000000010 X16=0000ffffb3880128
X17=0000ffffb4a86c80 X18=0000000000000000 X19=0000aaaaf384f8a0
X20=0000aaaaf37cec80 X21=0000aaaaf37c7210 X22=0000aaaaf37c9550
X23=0000aaaaf37c74e0 X24=0000ffffb3b47fc8 X25=0000ffffb3b47fc8
X26=0000ffffb3b43c78 X27=0000aaaaf37e1840 X28=0000aaaaf37cee50
X29=0000ffffecbf1a60 X30=0000ffffb364b530  SP=0000ffffecbf1a60
PSTATE=0000000020001000 --C- EL0t
```

After bisecting I reach to your commit.

```
28e3918179aa75cfd4490b3b0281496ed91d829a  drm/gem-shmem:
Track folio accessed/dirty status in mmap
```

It still reproducible in the 7.1-rc4 (ab5fce87a778).

Appling the following patch (Boris suggestion) fixes the issue for me.

```
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c 
b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 545933c7f712..1e036f69c1ce 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -696,7 +696,7 @@ const struct vm_operations_struct 
drm_gem_shmem_vm_ops = {
  #endif
         .open = drm_gem_shmem_vm_open,
         .close = drm_gem_shmem_vm_close,
-       .pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
+//     .pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
  };
  EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
```

I'm not familiar with the drm_gem, code so I don't any more insightful 
information
to share.  But hopefully we can find a better fix for this.

BR,
Igor Torrente

> ---
>   drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index c3a054899ba3..0c86ad40a049 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>   	if (ret != VM_FAULT_NOPAGE)
>   		ret = vmf_insert_pfn(vma, vmf->address, pfn);
>   
> +	if (likely(!(ret & VM_FAULT_ERROR)))
> +		folio_mark_accessed(folio);
> +
>   out:
>   	dma_resv_unlock(obj->resv);
>   
> @@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>   	drm_gem_vm_close(vma);
>   }
>   
> +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct drm_gem_object *obj = vma->vm_private_data;
> +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> +	struct page *page = shmem->pages[page_offset];
> +	struct folio *folio = page_folio(page);
> +
> +	file_update_time(vma->vm_file);
> +
> +	folio_mark_dirty(folio);
> +
> +	return 0;
> +}
> +
>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>   	.fault = drm_gem_shmem_fault,
>   	.open = drm_gem_shmem_vm_open,
>   	.close = drm_gem_shmem_vm_close,
> +	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>   };
>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>   

