Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE69E7FDF3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 22:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9326B0005; Mon,  2 Feb 2026 17:13:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8870B6B0088; Mon,  2 Feb 2026 17:13:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768996B0089; Mon,  2 Feb 2026 17:13:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 668C56B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:13:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 084951602D3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:13:29 +0000 (UTC)
X-FDA: 84400918938.25.F127A3F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3A59C000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:13:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ltf0x0Wy;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770070407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NetS+z/lB9Vjk8awsEzStStR7YjfBL5uvT3v62JS7ho=;
	b=FbKP/CzfEOrgDbNAE+fB96jlJINDLOMCVvZ5QxjxJjnT1WwfF5YqSz3ocBzA8LtINoi5Lf
	8zNta4GOb6q3G8scp7ZLdCyrUB3y3xnAlwC7zgrTfmJYXkx8NPE0i3CxqNcIzF/Qhs5t4P
	d2HcxvSczZaIrIiWl6y03T54MKuPUj4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ltf0x0Wy;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770070407; a=rsa-sha256;
	cv=none;
	b=gBa6UrertqvT7MBPBH8NzT2htcWMcpe4rtxnkQiSN5V27Fq8QgursLpXoB2N0JLQYW3Scl
	EWpq7kAQqcysvtq5RXSpKEGJZb61Fj3dcYZa3zQ2+AarKcpPS+8T6btXHdXReS0luA0qz6
	B75FU55qaoUq9cUJZtzRo2Ylz2F5AlQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770070406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NetS+z/lB9Vjk8awsEzStStR7YjfBL5uvT3v62JS7ho=;
	b=Ltf0x0Wy6kmHmj9tEr/RbFjqlhD1gTcAYB/I2Z+GFR4RahbluTBUL0et5uLkf/vIrkSwfh
	OAty3MRPDLL9JmdwicGbvQJBMjmGwT04xQLibrjXDhByihzL5PGyB8Sdte77VLy48m7qOj
	vkh2faPXgzcAmDgIBXPJ6IlpRr2P7bQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-TtmtPVcQPeyjhWPq3AjbXQ-1; Mon, 02 Feb 2026 17:13:25 -0500
X-MC-Unique: TtmtPVcQPeyjhWPq3AjbXQ-1
X-Mimecast-MFC-AGG-ID: TtmtPVcQPeyjhWPq3AjbXQ_1770070404
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-503810dba87so273186331cf.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 14:13:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770070404; x=1770675204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NetS+z/lB9Vjk8awsEzStStR7YjfBL5uvT3v62JS7ho=;
        b=ocaJLChJy24+tnA0K0SwhvxQrFz5fl1EQsDtdV582X5cKKv7/yTBK6veQZwPVUun1B
         TRe/FhTNwsQa8ekfFo/Ei4FGM0ubngnY/6RybvNW440+g9JgtB7uB0QNGz7wDhf8mARB
         ryOonjavoM+TcJJ8Yh2YDTyxEZtnbiNG4puTuTqXt/JoUu8K37GMZJhk8sy2iJaRFyy6
         UNmHW/3RrjFvXFH1Vmq1JTaQMpLsVCces0Pu9SqHtjgJq1JUU29A4Z/7n+wjzOef3NwV
         jNFHz7ApXGhwIo1WBhGDLiwny5uTy3in3rscKubmdnBY076zH132aA3OG0n7+YFFfuoo
         ke+g==
X-Gm-Message-State: AOJu0YzI31HHDDdg4/gjjywzWXVYE9HRh+15KD23rbnazzOSkmbaYN3X
	uL4wv2ZqrnGSg+MOo1yjZeeFIBS+mhNCysQcOoSQEr0FIt3csjsM/bD6I+nEr8ubl92WblkuuB1
	K4jpg0yBovwHX/KxcJUbSh3PTbY6um9ELlw/LamAFAwd/wkUCz+8d
X-Gm-Gg: AZuq6aI+//UQjVg15Fg1zksML5tUaZfm4lyiIHUFCaO8cUt7Q1Jiju9viIFwsWwBpf/
	BAZNihRCmuNlNxS/JWemOFp5JGOSkoqAPjMcEKPjbtXs+Pw2VXTIhBvWhIwSbV1/Z1QS0+bgeJr
	1Ty7BaAaStuEhAmeVnNiiYJwA5F+3bpBcLzN0wo38u2+JLflEYZPOt+tEmW38BaUewnhqsKcRUX
	amrFfyyFfimegWZHkloPoyx0/Ag5k7sfTQDA2V1vdrxh1uYNtV/TGkky5mGyvkFA+pvc85JUGPE
	XFN+FSWcFOysRztLpVH+X8WxFSy6GbEkxRgEaEA5QhU/apdJ/xlVeZjFBUx2voTqPIyaEVNXrtW
	yLPY=
X-Received: by 2002:a05:622a:28d:b0:4ed:af59:9df0 with SMTP id d75a77b69052e-505d228ac43mr152974651cf.40.1770070404194;
        Mon, 02 Feb 2026 14:13:24 -0800 (PST)
X-Received: by 2002:a05:622a:28d:b0:4ed:af59:9df0 with SMTP id d75a77b69052e-505d228ac43mr152974231cf.40.1770070403763;
        Mon, 02 Feb 2026 14:13:23 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50489d1b52csm101407911cf.8.2026.02.02.14.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 14:13:23 -0800 (PST)
Date: Mon, 2 Feb 2026 17:13:20 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 09/17] userfaultfd: introduce
 vm_uffd_ops->alloc_folio()
Message-ID: <aYEhgA1dY0biVYb8@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-10-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260127192936.1250096-10-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s6jRvx0OXZe2taHgNebDXPJBJj3HuxEpHz25bZLgiR8_1770070404
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3A59C000C
X-Stat-Signature: hjy76ixkparyjz1fabzyf613449t8rh8
X-Rspam-User: 
X-HE-Tag: 1770070406-620611
X-HE-Meta: U2FsdGVkX180okST/BiP7QKuWMKArjQVAamuX4Qx3Np4IU5xOuJGr8FAf4aA5lIfktzYbj3LtcPg2iXkgdhYFfmg/fi2Y87uoDQpQ4RopaotckqtNoiWW2TrjP0FremlI2MLr63aKa9RRWUQc8gkETEWReS7/1XIUNHU4YpuDw9tXNQcfkdNFoLuoknD36xxS0prPDsiq4/fUW4Z0Pe33IA8vuisbTN9aauHJ3hxe+xtEBjKPu8//crVXXgy+KQjDO9jXQRedeGaMaEaBvJ4pBw5YHwFsGx9xgOPBXwoj7ryHfnZ7GbAqET1AghxFKcD/ToobOWCpdCbEmiwyDVJIkRexXPGVlQq0g16wTp1hihd5sUZmD4ye2fkHS2ziU55+s/M+YSBfKBaqY0tP6xqni00bE+cLZHrE7APncevBBOOO5/1imEIjeVgp6BoBZXDfJViD8XQ7J2Q68GjFiz7eSDtNyzTAQYoayWRC5XrHrh6OkqV0pyEXKJKeM/pVTeWSNfEVRpdWEF0D+Nr4wBy817NPCuMJLoOkkW/opWTErXCM8+4bA2i797P4pEtL99PxuW0O2t0oNtjjdHxxmAc871Am2OJtFI0M9JMJJ3/DvK0S7yMSMreJOvFBiaVIK9XR6hdsll4mKp6R2AyLK2xJPmLkTSELs1nD1VNijq9nBbuU1Rb4QQ7IGJLVFq1fb7flYw7ujrWUU950g5cLF0wRyF5HE4xqfiKntZ8SDMXpGgLGMn6Yx2NMpCbLIsqXqeUIZ0NWs7/D1KnI343mlApAHoW3LuvOcgss+zxUSRJnlxI3x+TIacxxQaEPjEkcwJXbb83bQ8a8cf4z7WvpxRT9i0ZcrwGwyD90K2hyoKbJ8IBvdeVSR1H44gpogZswY55HbKny1mkt1gZOn6eowB7YvSsCNporxit7EHQI10TcH7YqpJq4mUi5qLgG9CYv0QDKDVT5PqGh9KmYAPry8G
 R+KVu07c
 /nWea7G0B5gIkG20l1yItY3RGzhnxoOQSS86y83j0rcTAeGMcIvGc3Be2C0v7hSJTik3j7RGqKbRpggsXncj8cW66efKoa9wu6lvOpNwgJYvmp7eFe15EIzumViSxcMnPLCOkWvQOOozbVWkS+BhLJEZC26XElAFu1j1l8ERbSp8rAx9yobq8vhQ1ypm7M0feIgworND/x4JBb3iI5UWXyN9Zkw+dORZs0lVLOZFDThP1G4WdhMj6ZNhxDCTJwHWkYCUbU8Khx6jdHt764iZF/GbXN7M31YsR6BAUyGbubt++Fok0ciZqauiqYRvmJRn6uDVK/4D8oghoLS9BYwVYiVipcabwGRGEDJ3U54g2Dv6z89aoIeuXcoe4Id+maSWFyq9uORWdoX8oFs/ZBRCh/XE86NibzAqj8bgoUPpdF+ogsAJvffD2tTjsyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 09:29:28PM +0200, Mike Rapoport wrote:

[...]

> -static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> -					 struct vm_area_struct *dst_vma,
> -					 unsigned long dst_addr)
> +static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
> -	struct folio *folio;
> -	int ret = -ENOMEM;
> -
> -	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> -	if (!folio)
> -		return ret;
> -
> -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> -		goto out_put;
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>  
> -	/*
> -	 * The memory barrier inside __folio_mark_uptodate makes sure that
> -	 * zeroing out the folio become visible before mapping the page
> -	 * using set_pte_at(). See do_anonymous_page().
> -	 */
> -	__folio_mark_uptodate(folio);
> +	return __mfill_atomic_pte(state, ops);
> +}
>  
> -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -				       &folio->page, true, 0);
> -	if (ret)
> -		goto out_put;
> +static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
> +{
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>  
> -	return 0;
> -out_put:
> -	folio_put(folio);
> -	return ret;
> +	return __mfill_atomic_pte(state, ops);
>  }
>  
>  static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> @@ -542,7 +546,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
>  	int ret;
>  
>  	if (mm_forbids_zeropage(dst_vma->vm_mm))
> -		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
> +		return mfill_atomic_pte_zeroed_folio(state);

After this patch, mfill_atomic_pte_zeroed_folio() should be 100% the same
impl with mfill_atomic_pte_copy(), so IIUC we can drop it.

>  
>  	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
>  					 dst_vma->vm_page_prot));
> -- 
> 2.51.0
> 

-- 
Peter Xu


