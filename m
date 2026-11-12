Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F156606A88E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=N+ytHqQi
Received: by kanga.kvack.org (Postfix)
	id 2324B6B05B0; Thu, 12 Nov 2026 07:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208E96B05B3; Thu, 12 Nov 2026 07:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FA96B05B5; Thu, 12 Nov 2026 07:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC4AF6B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:48:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71FCC14057E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:48:56 +0000 (UTC)
X-FDA: 85426446672.30.F3B57F9
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5C34A20004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:48:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=N+ytHqQi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf31.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794487734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpPYP3LwQ7UH65N0IOsMYcszMsGFfM1KkS0iQ4klOAA=;
	b=hSDw1SEOgETXOVGcno/Zt7mHi58sAWg44KBA/FDSIyFD66yEGnkL5610/7ifIhpX1QPuzZ
	CD66OoJLBhexTGfsV7PnJdo0k/zfNMHI3k6d8EORWMhc5g3mglBvCilrS9X22WVBGiYWZ5
	UwziicSz44ejADU5llcozCvL4I4Sc3M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794487734;
	b=pI66b2xiAmZGZkrlA3GZTP780bIVks//yUsTXIZvvBKlArLUT1k7omricIlXzvdKWSSpw6
	NsIeMlSgsnNV/iTqhKP2v6+rjt36czHOFcPfmbMnWseVtXh0HnVSHqr2GleQqJlKXeejs7
	1M5CrgbUX/dLtixwV4N8VFgQ47HCD2s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=N+ytHqQi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf31.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso37214395e9.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794487733; x=1795092533; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fpPYP3LwQ7UH65N0IOsMYcszMsGFfM1KkS0iQ4klOAA=;
        b=N+ytHqQiNsbOuvzBHmXUEYnmxX9kUy/U7n1YOV7V6S/vl56hsDeVR3UU2u+EbKGaDR
         oZRN79W5hHsGdHH3zwcv18bOkSNt83fhd0+jDjce+EvOzYhJ4ql3ssueQaz8F9GnYp93
         pIecMoDlGKhyVoTyo790Yxr3f+LSZTgma3rVbM8aaA98U7smBUWG+fDUu7n82K5Yt5rt
         YAqll4EEe9Yct0R4AmNMSAvf90W3pZ1I1l1lpEPPlIUvKq25ImAriJ5DevWMkIAaMfl+
         OWXfy2XRoCYnL1AlSIQMSS6XlpMRfpruPLfF+hiFKXuQABNWKducXJXZFOxWU4TGwq8A
         l//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487733; x=1795092533;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fpPYP3LwQ7UH65N0IOsMYcszMsGFfM1KkS0iQ4klOAA=;
        b=1f58fRNlbUVmNL3rQUqF/EKOdAjhnc7N7w6bc5uZSXu675UVG5Clse4r/VC7sGSkL2
         ytK2t2/LMyknWYjPV1ioV1W/q4FXDC+MM2OGaAfR8Y9uVg0tfvWGtxr6cj7wBKuEHmy0
         SiA4JSCckhswK4DdM8jxwclmNBv/ZV2QdUl+PSZMgRCRSYpxfSJcRUFRTpb/r3iLBruB
         maFvQ1Z8+MR5guWWRkw153HxYREqLPIE+MAOr1AdLYOGJfjZpCL7hv8Et67CcmmwPDon
         kBF/DGRaTTsMps+sxdueSZ/Ee4MzYfzKOPIUS2XoGqh6g/Ge4LayT9N8gqg+53uNilzG
         64JA==
X-Forwarded-Encrypted: i=1; AL+hErE+eA2zbBtEgGq/o5O1yIKZSqfNepQ5fj2gfVo+PW5DDghWMEkstDbIO9nDtw9O7OY8muw9f7slMQ==@kvack.org
X-Gm-Message-State: APuU4Z9fD0lWLHWOtwI7KY0VtGYJZp6o3I2vAJUXL6gnLGHN1W6LCl67
	j8eTzshZUnFs9YOllG5OdqUYaZmMOP+247Eo5LZGXzfywMnIVWUv6uAMOAbISkezHl4=
X-Gm-Gg: AYBFou3xjCSbs9dvaWqxJOEKSrNkxS42a1fF3/HDyWDKdM0P+L92c7F3dQaoNDuyVKG
	jDQyBSMn+HrBLw9QFVs8UNodyrPGEsKgUPKFPVcRybBCFAKwf9CD9mGqiBZqCjPcyQf7OyBxEHt
	jo0aOk2C2eScfvzLagERMNloMYnBkOMQUkhY00tkTtLlixVv8NmC/j+PlhV/K6F1RJsBOAm8p+1
	WeGeqo20GeHDc3tkY9ts2CIjgeevbTxkVNNQHC5zSwxUXDwqbepep71+dWoLKKZmdS07GKNDndg
	NDdCwS1tBglnirHIN5lO7/HS1e/IH7iWOG2UaBhTIelALJezxM73vlFcOw9MnD3OUKghuGPQTVG
	Sc4oa25NLSDgBKa5uutAwFro+VKIwx/Bw5vZAa0zy0qD323E3Vae3+iwszzBUat1fT6gCegJTiP
	joyGbZQW9ctfr+ipuWyQ1E9+vgY/+ZgQT28/T1Nf8VVy9lfb9vDaWGUeHb87U2OnPunjj4Jyh0r
	WqeC8d+nHGkfB1H3vyuXANC4TsMjnxwuXoptiSMMpLu47UA1MYL0FSykL7+vv+7Wp37sn44Ibbg
	gX+WaUk9WmvCRQp2ELgW3doUiRfueyXUFbgDTsML8jo=
X-Received: by 2002:a05:600c:190a:b0:4a7:9006:b176 with SMTP id 5b1f17b1804b1-4ba0936c8bfmr102512485e9.7.1794487732984;
        Thu, 12 Nov 2026 04:48:52 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e251491sm71286495e9.2.2026.11.12.04.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:48:52 -0800 (PST)
Date: Thu, 12 Nov 2026 13:48:51 +0100
From: Michal Hocko <mhocko@suse.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
	Balbir Singh <balbirs@nvidia.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>,
	Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avW1s2wvz1PB0-Ln@tiehlicka>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <avWmfXu39vtp0DM9@tiehlicka>
 <avWsG-zmuniUFio7@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avWsG-zmuniUFio7@gremlin>
X-Stat-Signature: c7gghdbhc4wytbxmisi9j3qx9z7xtmem
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C34A20004
X-HE-Tag: 1794487734-132174
X-HE-Meta: U2FsdGVkX199miv/AwM5tsW8FmNKIxydA6KTJwehuYi4lKrOdiFyqqRAXmg54YfDceNMM2vIoYGBZw9q3EoCNATAARk67l4x5NsUt13wSV9T/1lN3p8y7Qd5Qpco0xIFClvxsOqkaF/H248JWDWvsiw288CgvVvmZp7X36zY3rTgi/CL1ba7QH70D/PNQginRhqdRrRoMA6DwkaZU6tSC4kr6QLO/gwN7VuczvbyDCKdj5MXVwFrnYWAMfiSFzQUhks8sI6ITDJps9qHSc8c/cmd4SNF0rKztKnka+Y4m3SOTgww1mXAQvrZTRoOKV45HW/oHmfJXz0yDO94BpSIIYBJ1eufbEmSUngHjJez9hDxR+ZPD4dhvxuA0YToJuklSTkolWS3Hrcub7LzSFWBhYkJYOnSKu8JwIx7LLUQKXDYb6OO+gPGN0Y1a2gLzvYkCpwyslCTLIB47S8q2rjN+S7oPg6/20QoXnMyEfDKMAuTF5HevjYVmPJJk3A5CVrP+w7ghZtTziP/OB5dLLyL4DoL411uP5j0kmY+lDdoo1uNMHrWRMJhtW5xcAxp/bVp5raEZpm8Ye4TYDxvhGHAC2ccHwwAYZ7scVEUaHoZ/MTKDn2ahqCn2q+3hhid238b0FwpIQnpaBkgpshcHOS/K5Rj+Piz1pLrJgK/1nRjdRJyNGjiGlnftrDryewXNnzqWRzcsRN4V6MeNcDF6xVsz2xQPaWp+6YtwOKDvvnYP6K2ubDjv9ysFUh4tBTaSG2kToS0iLTQa9JG4xz24BlIUsLac8ctDh4cpJN++k0RWji5mT9dxBpBQoPZf++3xzU4m8h3vUu+WuGJX++9FOAg/xZxj4BRAx3ysGiNYt8+BOm86b4doxOuieXD9qtFctu6yq+jmQH1Dq3nypn93dLeMIVFu3gJhYiBKnZM8KjcJDsUJkJMPHvionCntG8AregIdMXXKqIlPWyQvEte7TR
 5XQC3Cu8
 BPdrYud016uSpBMmc6p0lgq1bQWmpFn5O9Wxf25xohC6gr/fbaUeZng4Sw69PLQIDGPJtDGNC8+OiE3aInbr4NIXfuG9AJ4ukQaUCepHY5DsapNB4lEwxhq1JHaT/FSiWiulnMsSa2N4QFtqBEuxGBkwtkuckXCwybeY/0wp3wePFbUu5TzQQCl+JNLohbToyaA22DttMpC7sRXT5Ry0buVzWfWIS9O6Vvsa91r12R7YR69c1PzyGLLdg1ntxQyn2E2+R2VUFTVPL8pErTiiPaCK8cJzQbItyyJgBZLQDnCPwzbdHtqIDxBaMQJPSsUhQUQyxYakAS9nNZfidL4JSqP6MHWxNtPUZbZ3CjpXrXJbXIMNyIbHfJ/Cm8CgYVI3js3IxjhUqw0QrWDp5r2vO/kMI2bS7NsSqaVmnd7v8MBSFa0/x0ndw4eeGsX0pMDan22SWbrgsUU/2PH8d/wfBEXlVnF1ZE2WLNPiK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 12-11-26 12:14:32, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 12, 2026 at 12:43:57PM +0100, Michal Hocko wrote:
> > On Wed 11-11-26 18:13:15, Lorenzo Stoakes (ARM) wrote:
> > > The OOM killer can quickly trigger again after having selected a
> > > victim. That victim might not have freed its memory yet, but its mm will
> > > be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.
> > >
> > > This can cause the OOM killer to kill an innocent process when the first
> > > might have freed enough memory to relieve the memory pressure.
> > >
> > > Fix the issue by freeing the memory before marking the mm MMF_OOM_SKIP.
> > >
> > > Note that the task which calls mmput() might not be the victim - if it
> > > took a reference on the mm (e.g. ptrace), it may hold the last reference
> > > and release it when it calls mmput().
> >
> > I do not follow the reasoning here. MMF_OOM_SKIP is called after the
> > address space has been unmapped either by the last mmput or the
> > oom_reaper (or both when they are racing). Now all your patch does is to
> > call tlb_flush_mmu which I suspect is to release batched pages. But why
> > is that needed only for the oom victim and why there was no final flush
> > in unmap_vmas?
> 
> Sorry maybe commit message isn't clear enough. I did have to pare these down
> from really massive ones.
> 
> And yeah tlb_flush_mmu() is about freeing the batches.
> 
> unmap_vmas() doesn't have a final flush, it relies on the caller to figure that
> out, and just batches up.
> 
> And currently tlb_finish_mmu() comes after MMF_OOM_SKIP is set (in
> exit_mmap()), so at that point the memory is unmapped but whatever the last
> batch is isn't freed yet, and the batch can be large (PMDs are single
> entries if I recall correctly for e.g.).

OK, this makes more sense.

> This only matters for the OOM victim, hence reinstating MMF_OOM_VICTIM, which
> made the patch _way_ smaller than the one proposed :)

Should we simply do that flushing unconditionally before setting MMF_OOM_VICTIM
then?
-- 
Michal Hocko
SUSE Labs

