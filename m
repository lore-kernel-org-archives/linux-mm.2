Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7C4606A336
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=fNin2XXh
Received: by kanga.kvack.org (Postfix)
	id 33C726B05B4; Mon, 16 Nov 2026 08:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED886B05B6; Mon, 16 Nov 2026 08:22:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5286B05B7; Mon, 16 Nov 2026 08:22:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E36576B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:22:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7812E120145
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:22:58 +0000 (UTC)
X-FDA: 85441047636.12.89E69DF
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8FA898000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:22:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fNin2XXh;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.51 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794835376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ip0og70Tt8f+28eOZ5F6oTc6DjrtMrQ1wymW+Uokrdw=;
	b=l8QQ9B3EQEbqspvjGP8D9iro4hDSVSWAOSjmGpVVR1NKDG+UiJzzZsYI9KUUpMj/2aH6pt
	QUaG0jECJ7PBsq6G0wiX37WbTANk3aLq6F9nXFX0cvsP6EBhmHSBBCsfmRdlZdet8nEPko
	PnD79dAYyv035gvFB+KdYPEqaG4mXoI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794835376;
	b=Cm/i7E85GzbIC39LvVp7DjqAJd5VeMV7swCyce1nOG9gptGEIltTMLs50SMiRds+IHXq8K
	RoJec3NJSPsSwJB6+b/Cn1kObh8MBqbpwiwVWWqKm2Y5SBvhpA1JE9Lb2pVeR56FAzBjFs
	agn/bV4UmVbE6vtDh7X5OBH54c4HMgE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fNin2XXh;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.51 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91ea2e29d90so52031946d6.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794835376; x=1795440176; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ip0og70Tt8f+28eOZ5F6oTc6DjrtMrQ1wymW+Uokrdw=;
        b=fNin2XXh1gXIVLaW4haBCenbYHFY+n+tI4VU193iNzXo20cYYjTapHsNu0ad6B7IFv
         J45j+JqRUUkRTEJksTmAPKmu6n2QIifYz3fPfij5VS1kXtTz0CF+ERrEUCqID3tKX9nx
         6KwpnxV2V2T1MOpsEy2467agj1mnqba941Gl5M5NuEi7DvaNwv1GLCvzH0vpi+/Y6k37
         EuHDvA7JY8RY6/Xad+NZLknrGhgDlDYnOaCZF7mSni8hJk/uI5teDYxjJ+cC1hFdoaSh
         imRhu+jMREZyh6TosRzHcuLfSWoM/1T2YiFZPpA/tdyuK9Fhuf8olkwALQBGPp6sraTr
         wdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794835376; x=1795440176;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ip0og70Tt8f+28eOZ5F6oTc6DjrtMrQ1wymW+Uokrdw=;
        b=em9erxYOWoxz46z0FyIAmVQQk+JkZmD9gJCSpnHO4z8oNWDiYAmWuFeX9OXEIxITXq
         8OooMHZAhDuJgs3Ok8XojPk/k8+K+UwvTfDxAi6arLCFRwsSaWIyX3I5o5ypjlq5rAaO
         T47kFINDmUlA06REP9NotccUfxXoiJuSjQXDDnL74Oq6OiWJE9zHpHYj2xZLrfghNx71
         l9ff1etfd++1DAofmKExURVo/LoeW0iBdUev7jHjpidAhjNwE9YXGcYmdMINuO/vTULF
         iOTWmYB7Pz8Pry+1ybJsloyMJPeMgelESe4MvAnbAzby2GHEgHyed5GZpGiaRkIs/9Rg
         zc+g==
X-Forwarded-Encrypted: i=1; AL+hErH5Y8n/v9fY9R9djdKkl+ClqkObffyovOioKaQhJeGSYCMBs0v8zM8fqJzKJ/qQhNC7tkGyE4PJRg==@kvack.org
X-Gm-Message-State: APuU4Z+E4NA4jc4NiI3SlRhOu3n09YWEYXelRvZTE1T8e5DgF/1bE/I+
	ZdsCCK32AkDkEjc57J8ZfKtUOUheW6J1AJqI5AQFW5YIdQEgUFq5a/znOfxc+tasXeA=
X-Gm-Gg: AYBFou3WlYaIYnjcbiqjQS7LFHTFM3hh2d7p4di/HS/MlMwKthet78gdjHf3Apxz9f8
	SHjo6ZiyRbtdH1xTJ3dMkkPHiRmGi4jyRQpa6GVb1T6ggijwYHp8On80P78lgBBa/ZeV5WLwjU7
	iZkj57FYmlcAEVLe3OJkNnc2XN5tgHfbBf08nxGpYziXI3tpzZIuI1RTbx4r0Rp6x4VGr+MAFqj
	53DbNr+xDqSWqTS/xKCHHcdE+HKGKeyxVgoA1wfk2EpiYIuQQYN+dYkUzAiPAIc3GaGUIYT+VHP
	e1bfXTQUTgMrZ2WpH+Oj+zXO3YFoUjqggo/DRdAjMK3hXugBf8yg9vTt3JqIVz/jrP9nJtfv6pP
	I604DaF3u6O8VKzCQWIHaNuOavrceg3jEJ4nGxbW9m1xZa+1CSOvk3h2g0XTPlyZ5xROQ1LFnA0
	YG+APRb1Df0bHn+XsNPuMrtU830sak79w8LCJcXWlphdyt1klbglb3ztAq8/foNiEsqxl/1/B5/
	Or7t6vUT25QHIho6HWMete/Ozwse4wJbWTe28xUuQy8sb/nWvcqnBSI368+GcutC6ob7vZDvp9b
	+FDlEQ==
X-Received: by 2002:a05:622a:e190:20b0:55b:9d8d:f29e with SMTP id d75a77b69052e-55b9d8df528mr93734571cf.9.1794835373441;
        Mon, 16 Nov 2026 05:22:53 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad0f07afesm80824241cf.16.2026.11.16.05.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 05:22:52 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSwfb-00000009Kvw-33KL;
	Mon, 16 Nov 2026 09:22:51 -0400
Date: Mon, 16 Nov 2026 09:22:51 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Michael Roth <michael.roth@amd.com>, pankaj.gupta@amd.com
Subject: Re: [PATCH v10 00/13] coco: guest: Add a shared-granule allocator
 for host-shared memory
Message-ID: <20261116132251.GJ2532299@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <0524abf4-2306-4046-aade-c23aa7d1e0e6@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0524abf4-2306-4046-aade-c23aa7d1e0e6@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8FA898000D
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5asw7rcb9db6dpg37u7dgafmf7gnrddn
X-Rspam-User: 
X-HE-Tag: 1794835376-91628
X-HE-Meta: U2FsdGVkX18BSR4UJkEBY2o4NzXYUQhlGBeeK6Bpx75+dNCykDABtepY4R+6us3LVKESsN+CNy6T5EVH6Za7VAQiAvC4buxz8t6cCqlZ4UrJ/qnmHCNGe0B/MjEM7Sg1Z7y9QPa0QcQZKU1Tn+vzLY2K45phF37kpu0+Kngz63I9ikU9a543QWbx8Y5Hcxo3LSX/iE1BZjWnBGl7b28v59YTOdJF7aHP5el0nAVHde9WKZP4WHnF4gvR7hXkEbEocUNMTtQngoJ9XHVvj6coPdR+I7GfbmmZGK8ByByMSlt7jlbYbg0TGK20tTPorics4R9vKzdAQH8S1Xl1D583/aXseheqNHblMDPxJYBKmeB+zVgne63eF2ecAXKTLKWE1pL2oQItmXAv0mXNI43/k8LN9j2Gv558kzR23XwaK68dzgDKJRtxkwQfa8ElsZG4pw9Igz9GYaC6ueTGXay/pY3JN2kd2Kdzj4eYO9FyhI/3yt0qUzQDE9kJGMFcQzF2dJiAexDKMCPknzWJvJgr+kOyzAcpb9FsBfLdb/rt84//hcZREooRx122GyiSfmDnlYJEFrHUDHx4yOH9lUz9kD20IAfLmh+sF0I848LDlS3RVSKQTIC5DEzKtdI+Eq3NcaUta/KaYsayVypEXvWIboaNYh0ELHKu1tsuzRu7oTJr1pywAZ77ZnUrFEn8oYvrdvzzqOcEWXP0NcGZ84c1mL4Nj9wV8Uf52RRAL2Du/m/r7rbe5DCG8oA1KGo+dzo9o5PSakp5uiJVoIAnzyXELZZmHWwvk0sMtmlEZbNLlBZrXMxKRYyaKDTMF80yPkgMoKkAu3TkhlEGFjdGd3ufgyoy2HCnTRL0lwMgdJfsYGNY6srcg2GENNhYTgjEmtdljfXWvWsmvuWubccAkOR2rXCp5e2GyufHlS+vtO1vBRUVTRqGCNebhPRCE7lQzpfVMighljVVH5ZU4FIxwAf
 yO5f8FUT
 FZsddmOalkLjcF9ey2PpfpyIbTOHa2bpRq2NkbJga3J/NJC8w3kF+IZQNPFlJBbaJ9WoJT4HXlvNPZox7JRLSVI9r1n6sBDqIEKiqknhck9GPZXXqzcWXRn8M4WVA3yS+U5AcO/ywrMMTImfZR21V031TNgR0F8tw2FCaB5rsAMBOKMrDde/8SZk/DF4JWEw3em6GxFXIMNRPkbhfIbnbdhvnRbUveWqqHYSzm8gHOR8UbM9Omi9yvJkZij1rkJ84hRsV75+PS5SjMIf2nVAVuoSeWzT0JgllIXaDzv7fVPEu3RgKo4t/RvKZb+ltOd4wF+HjiN0tJO9vUB1Wb1Y7/kJ5vxE4f2IPBJqqhRsuL20HdNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 10:09:35AM +0000, Suzuki K Poulose wrote:
> Cc Michael Roth, Alexey, Pankaj Gupta
> 
> On 16/11/2026 09:11, Aneesh Kumar K.V (Arm) wrote:
> > 
> > This series tightens the alignment requirements for buffers that are shared
> > between confidential-computing guests and the host, and adds a common
> > allocator for host-shared memory.
> > 
> > When a guest runs with private memory, buffers shared with the hypervisor
> > are not only accessed by the guest. They are also accessed by the host
> > kernel, and the host may manage the corresponding shared/private state at a
> > granularity larger than the guest page size.
> > 
> > Architectures such as Arm can detect incorrect accesses to Realm physical
> > address space PFNs through GPC faults. However, relying on that as the only
> > line of defence is fragile and can still lead to kernel crashes. The risk
> > is especially visible for shared buffers that are later mmapped into
> > userspace, such as guest_memfd or dma-buf backed allocations. Once
> > userspace can access the mapping, the kernel cannot guarantee that
> > applications will only touch the intended 4K region rather than the whole
> > host page mapped into their address space. Those userspace addresses may
> > also be passed back into the kernel and accessed through the linear map,
> > resulting in a GPC fault.
> 
> IIUC, AMD SEV-SNP also has a similar requirement for other reasons, to
> align the "shared" allocations within a guest (2MB ?, as mentioned by
> David Kaplan at the LPC).
> 
> Michael, Alexey,
> 
> Please could you share your thoughts on this series ?

Yes, I think we concluded at LPC that AMD should use this series with
a 2MB setting rather than try to do their HW assisted smash/unsmash

Jason

