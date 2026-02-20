Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E0F2C5B56B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 21:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294F56B0005; Fri, 20 Feb 2026 16:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255596B0089; Fri, 20 Feb 2026 16:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141526B008A; Fri, 20 Feb 2026 16:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F134B6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:36:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93C241BF69
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 21:36:14 +0000 (UTC)
X-FDA: 84466143468.15.047CF4E
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 87819140008
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 21:36:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0bURw4f/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771623372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hz25v6lNfFpsqcoUVzeMgcEtFNoS0C98fF1StYX9804=;
	b=fVsxIfKZl0JgMzji+NEN3OMGv/dCpoM+FDqQj6Ol3v8XDamW34BTddmdyqPl/wLkcPN/NB
	6ONwcTW3HcYuQJbA47aW5QOzLJ1HjIhz6FsMo5r1+pir59WDUFhta/RwvSXGUzFUO7NiTq
	77XcdRhQEk3TrKoapAluT8ziBT4xCPU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771623372; a=rsa-sha256;
	cv=pass;
	b=igOUrgzKyULDxMzyFRL3NCuSVeXCQ7sBot/5NelWR2O0bMwJksc/R1i2KymXkakdmuBMhT
	8bKIsYOs0q/y0oalsT/f7ktvfJX4PWs/C4qC8ENy4NkAD158G+CUT7EBMjNDlgM4f4JaTU
	EQ9qsNBPydzIewxFa8D/5wSe4mH28eY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0bURw4f/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2aad8123335so7275ad.1
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 13:36:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771623371; cv=none;
        d=google.com; s=arc-20240605;
        b=jNSyuKGhk+aGRfPfB9KPHzosPUHrYREbMrogLYqZk1KoIoQ1kHcGRTVBjcMcrm0qYf
         1TWBbLL06nRVIed8iIpCBknxfNetZjlG2431PuM1cRrf0KGpoaz/cOOJbCEcc/nrAaDJ
         pJrNSr8Q6nC68a/JF7GFOxxDY6rN9y5C6fxKUUkA5Y5t0wXa5NDo5UCB3bRWpZ+exPgL
         dBQkCZgqJK9Y1bPEKN02XKqLuuIGwQan3DBBnwoQoiwArymcBM55v99MUbXZcoLM106v
         uk+HwJwfEmQx608m+F2huQ5APPqYki+stuxKe7ae24J7OZYWH8O+oXsxVqJtlsFZFBY9
         P+6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hz25v6lNfFpsqcoUVzeMgcEtFNoS0C98fF1StYX9804=;
        fh=T2xJoj5kZqIViHLkYyHZv68zlQzjIEUMSfKh3Ck1Fo0=;
        b=SSIjjmLRkR3WP3o5eSsQbgChjNWdZxGVmY599C7CUMqN4DGSFJCmjWWiB6bY/6Hf7A
         VaK36sjvKYlysBVFGciA/9UMZ60mdjXx2l6hEUSgcHmrKnNN5xNG5acFRre3xbKOVmuy
         sXvsMK4pR0qoSqLI242lpQrA7mBOZQsC6zLjMdG64Gi9k4uYoBbz8BEIWR3vjycxHIbw
         4Aw8OahOqI5QM1fl3AEA/VcBjfWkvDRTdfQ/nSUn/T5eyB/k6c5+DA/zeKRHhgjaXGQU
         jyXmNgz1sUELyHL6cqVzjXnGWnvKsG9nKGuIFGezqiW+KNNHhX/tMMPEVEBrSyn9ByqA
         6Ydw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771623371; x=1772228171; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hz25v6lNfFpsqcoUVzeMgcEtFNoS0C98fF1StYX9804=;
        b=0bURw4f/pM6WNT+2cGcf60eW0MEUyDNoN9urnc6Cv25L9QituqtLmTper8kJt0Jh19
         RD66br9HSy9MqDVkEDyYqsLj/UieQSJCJ25+l2kayC860RSfRiK3M2utJcOiL8t7gH8p
         8mShouVl+geKwbS2JbAC0u489hBHrKiz7XoJzKFiLzu5ikCH9cHZF7iirH/45lJeCBIu
         +jhLhqGbW00pTYynMkpa0APDd66EOKzZf8yYwB9DqBUfLFTNmzXOZH2hOJ3dKcd6NUmi
         GQnCEztwZR7OyVnsrrUiyXk5hwLlxx5JF1lwI9aFf2aK8qaDQV62/Ap5o0sudBfx/E8e
         bSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771623371; x=1772228171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hz25v6lNfFpsqcoUVzeMgcEtFNoS0C98fF1StYX9804=;
        b=bOWIB7spBBm7nY8OV1jhDAVYBOoG+fARV8uxuwhv4Qoyiw+bJVWyMp+aRbocUF9Wd5
         f+qOSQGL1itdSAmnuKbvNxIE3arUWm5XTybgJVoopYd2YlyfbYytfSZC02sQXl2JA1a7
         eq/HLt+gVGt5cRYndSZvM05MeooDWCqpZDjm0eRqE8U23GMK7aLEXkx5bModHDqRSpM1
         1MxShrJYbWpXOo2UjjOSzlepM+kgEAq/S+UiXH8YEFYDvkaRxXLk4VRMA/Ue2Ogl8nUz
         9F159lyd3gxqah6w5YxZpdYVSQhUtT186uDvn7whL5JsY3RLmmMEekvglPt7yy0+iXOD
         aRKw==
X-Gm-Message-State: AOJu0YxJpuBog1j6Zapd2f30HGLt/nm6i7FfXZu2hqw+JN4E+94pbwHM
	vKBpRub982CToKI97bOMOnsQhZVU/uIRxTikdLDZMJ89M2TXdcYsnSD8B6r+8y/xNfn+ATl9Twk
	W8ooF98vZHs8xZjBRWXMKqlJ0eBv3sDbY6Z8rTzk3
X-Gm-Gg: AZuq6aLt19Yq3tmhprIhWrpFIoMRHfilJ8AAr8vHx2Z7FpQ4vSEGAg1lNovYDS8eyJK
	ITrnC5vM3Ywy4Vhsp85q9ZYOh6Uol/RXdcMA0n/Kz5K5tdgMC/ZQRSEQnSZFyCDX2CzqHv1Xc1d
	F//FLBfWjJhfYlYupCOzjTk7Z680ftYSAvge5SpAiygw5JgErWEamGFr0139itIkyUxbJUPqDkt
	JKk+rBj90EH1yJdOzMaqH40RRDx1VUWx2G4HZrlUK0PVLRzXqPL1NWwTBIqMQWL1VbOvRmSxeIL
	hkMRpZgPxABkueljLt68KojV0P2+M3oehXMme7y9
X-Received: by 2002:a17:903:15ce:b0:2a7:5652:50b2 with SMTP id
 d9443c01a7336-2ad75d67a7fmr60225ad.9.1771623370611; Fri, 20 Feb 2026 13:36:10
 -0800 (PST)
MIME-Version: 1.0
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Fri, 20 Feb 2026 13:35:58 -0800
X-Gm-Features: AaiRm50GP3k8OLUJ3qKyKn32C8iCar6BHko2HVxt-jsOwPsBNQoXEdqDCA-OlWM
Message-ID: <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, andreyknvl@gmail.com, 
	arnd@arndb.de, bp@alien8.de, brauner@kernel.org, bsegall@google.com, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com, 
	dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com, 
	jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com, 
	khalid@kernel.org, liam.howlett@oracle.com, linyongting@bytedance.com, 
	lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com, 
	maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, osalvador@suse.de, 
	pcc@google.com, peterz@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com, 
	willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: qmiqdgtsqx7sygtdqm7nbyhgzutgxiw8
X-Rspamd-Queue-Id: 87819140008
X-Rspam-User: 
X-HE-Tag: 1771623372-676086
X-HE-Meta: U2FsdGVkX18m/UBD+f4j5ym0vRF0c+B5hx8fheV0XSyMTbF6e6BEhQZbXdgoO5IpT5BHJVI4ImK/+KXho0Yw7nTakRXSjyz+EeX+98JuKD5nmEYsvO+AhAzXxj9KcOUB59RKMwAW62TVtTgFUhbJ6qR31JqQsIp/ZDlxk7omp+0BJcBdBvwCB4xTg26Tb86bArkmoYGUrtVy5/WxzuDI9kOZ7sLsJSqKjX+y4WDrNjBLZctQJadWoLMHwAiYBb0FYuJOpWnGG+oWWXdfPOEp217XBCbjXxoeRTbt8qHe26eDtEX1S5SMh1fDPYLvpfN62AvLL9nKJEkM2/gEK03Zf4Gvk/dcN2vcZydl62V8dOl61H3CeOCX+2fl4D5XYoQ+uHO+PmnW6S+pPAeQFz7XPLe7UKNRXNoi9/fxerqhoFloWuFMDHzNW+wSvEBHTBgPHV4Rm/OfQ611WUvzK4SajKjXThPBxcgA1Y75pj5PaqY6WF4tvmLGfSHhSwuDY0o+IN3Kb7txFq6q8b8Jaw9a5SaK3GtEWfawkJLMWNLdRd1uaIHA7IZ5rnuPAtdbmS4I8Ss+0yH+GrDOXnWkgI1UXYExtxuq50pit2k1jA35RQ1Z+nq9EyAJXo8njREyh+7mUa2Dv7EMxooDFtf0g6jHfDQT8JmVRC7tKke6akiMcmZBI2+a0aqKzS0U31OMTLhvfVUgUZL/W/TLZ59g0wnRYRgdSx+mKsZ+BBk5xGFxU0/y6664ypaXBEEIJrH5GvEBEpil0qI3P0yjxAaX4I2xRG7pvzxVNvM+kqELSLzqfcWkiS4H4vhlhJIrat90vYyEgBhq072azcjH0s0EzGYZnith1QdKVpmHWvRQlxBwsCJQRlvdTRVaMiES7proNk0CJTBl1efAiHYWucGK0R9hqePBVrqGiDKbJYQioh0KFDQRK7YLm+/iZ5d4AQJYUUvkEa0IhxXSuj+dNejKcGK
 UYWYh+Zc
 CS8KQTTMqIcbKk5D6i3PfM7zJU8UWrvbb+rtf+7Pn/J89n+QxUn5AikqovFzQC2+ea4lbxxrSXQiS/ldMst7UKeJheNLwVVQB+eYStb7t6N2MNzA6yarYduUxyTp6tFX9/a5D3CbvryNY3O4bbQotSrHYPCbbNzO2al7h284ktFlRykc+s9WZdX32WGrIPdrQ7MKDTOQuTCndVyJY04wDSRwUukPP/3aQvoM3uaAzYUa2wH8BSiZC2vnOUf6aic5rPsPs49QkVuMvedqjEwpx/ARU9v3fOKbGAxQRsLbO2OSXJnDHvDKxa5QzWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 6:57=E2=80=AFPM Anthony Yznaga
<anthony.yznaga@oracle.com> wrote:
>
> Memory pages shared between processes require page table entries
> (PTEs) for each process. Each of these PTEs consume some of
> the memory and as long as the number of mappings being maintained
> is small enough, this space consumed by page tables is not
> objectionable. When very few memory pages are shared between
> processes, the number of PTEs to maintain is mostly constrained by
> the number of pages of memory on the system. As the number of shared
> pages and the number of times pages are shared goes up, amount of
> memory consumed by page tables starts to become significant. This
> issue does not apply to threads. Any number of threads can share the
> same pages inside a process while sharing the same PTEs. Extending
> this same model to sharing pages across processes can eliminate this
> issue for sharing across processes as well.
>
> Some of the field deployments commonly see memory pages shared
> across 1000s of processes. On x86_64, each page requires a PTE that
> is 8 bytes long which is very small compared to the 4K page
> size. When 2000 processes map the same page in their address space,
> each one of them requires 8 bytes for its PTE and together that adds
> up to 8K of memory just to hold the PTEs for one 4K page. On a
> database server with 300GB SGA, a system crash was seen with
> out-of-memory condition when 1500+ clients tried to share this SGA
> even though the system had 512GB of memory. On this server, in the
> worst case scenario of all 1500 processes mapping every page from
> SGA would have required 878GB+ for just the PTEs. If these PTEs
> could be shared, the a substantial amount of memory saved.
>
> This patch series implements a mechanism that allows userspace
> processes to opt into sharing PTEs. It adds a new in-memory
> filesystem - msharefs. A file created on msharefs represents a
> shared region where all processes mapping that region will map
> objects within it with shared PTEs. When the file is created,
> a new host mm struct is created to hold the shared page tables
> and vmas for objects later mapped into the shared region. This
> host mm struct is associated with the file and not with a task.
> When a process mmap's the shared region, a vm flag VM_MSHARE
> is added to the vma. On page fault the vma is checked for the
> presence of the VM_MSHARE flag. If found, the host mm is
> searched for a vma that covers the fault address. Fault handling
> then continues using that host vma which establishes PTEs in the
> host mm. Fault handling in a shared region also links the shared
> page table to the process page table if the shared page table
> already exists.
>
> Ioctls are used to map and unmap objects in the shared region and
> to (eventually) perform other operations on the shared objects such
> as changing protections.
>
> API
> =3D=3D=3D
>
> The steps to use this feature are:
>
> 1. Mount msharefs on /sys/fs/mshare -
>         mount -t msharefs msharefs /sys/fs/mshare
>
> 2. mshare regions have alignment and size requirements. The start
>    address for the region must be aligned to an address boundary and
>    be a multiple of fixed size. This alignment and size requirement
>    can be obtained by reading the file /sys/fs/mshare/mshare_info
>    which returns a number in text format. mshare regions must be
>    aligned to this boundary and be a multiple of this size.
>
> 3. For the process creating an mshare region:
>         a. Create a file on /sys/fs/mshare, for example -
>                 fd =3D open("/sys/fs/mshare/shareme",
>                                 O_RDWR|O_CREAT|O_EXCL, 0600);
>
>         b. Establish the size of the region
>                 ftruncate(fd, BUFFER_SIZE);
>
>         c. Map some memory in the region
>                 struct mshare_create mcreate;
>
>                 mcreate.region_offset =3D 0;
>                 mcreate.size =3D BUFFER_SIZE;
>                 mcreate.offset =3D 0;
>                 mcreate.prot =3D PROT_READ | PROT_WRITE;
>                 mcreate.flags =3D MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED;
>                 mcreate.fd =3D -1;
>
>                 ioctl(fd, MSHAREFS_CREATE_MAPPING, &mcreate)
>
>         d. Map the mshare region into the process
>                 mmap((void *)TB(2), BUFFER_SIZE, PROT_READ | PROT_WRITE,
>                         MAP_FIXED | MAP_SHARED, fd, 0);
>
>         e. Write and read to mshared region normally.
>
> 4. For processes attaching an mshare region:
>         a. Open the file on msharefs, for example -
>                 fd =3D open("/sys/fs/mshare/shareme", O_RDWR);
>
>         b. Get information about mshare'd region from the file:
>                 struct stat sb;
>
>                 fstat(fd, &sb);
>                 mshare_size =3D sb.st_size;
>
>         c. Map the mshare'd region into the process
>                 mmap((void *)TB(2), mshare_size, PROT_READ | PROT_WRITE,
>                         MAP_FIXED | MAP_SHARED, fd, 0);
>
> 5. To delete the mshare region -
>                 unlink("/sys/fs/mshare/shareme");
>
>
>
> Example Code
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Snippet of the code that a donor process would run looks like below:
>
> -----------------
>         struct mshare_create mcreate;
>
>         fd =3D open("/sys/fs/mshare/mshare_info", O_RDONLY);
>         read(fd, req, 128);
>         alignsize =3D atoi(req);
>         close(fd);
>         fd =3D open("/sys/fs/mshare/shareme", O_RDWR|O_CREAT|O_EXCL, 0600=
);
>         start =3D alignsize * 4;
>         size =3D alignsize * 2;
>
>         ftruncate(fd, size);
>
>         mcreate.region_offset =3D 0;
>         mcreate.size =3D size;
>         mcreate.offset =3D 0;
>         mcreate.prot =3D PROT_READ | PROT_WRITE;
>         mcreate.flags =3D MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED;
>         mcreate.fd =3D -1;
>         ret =3D ioctl(fd, MSHAREFS_CREATE_MAPPING, &mcreate);
>         if (ret < 0)
>                 perror("ERROR: MSHAREFS_CREATE_MAPPING");
>
>         addr =3D mmap((void *)start, size, PROT_READ | PROT_WRITE,
>                         MAP_FIXED | MAP_SHARED, fd, 0);
>         if (addr =3D=3D MAP_FAILED)
>                 perror("ERROR: mmap failed");
>
>         strncpy(addr, "Some random shared text",
>                         sizeof("Some random shared text"));
> -----------------
>
> Snippet of code that a consumer process would execute looks like:
>
> -----------------
>         fd =3D open("/sys/fs/mshare/shareme", O_RDONLY);
>
>         fstat(fd, &sb);
>         size =3D sb.st_size;
>
>         if (!size)
>                 perror("ERROR: mshare region not init'd");
>
>         addr =3D mmap(0, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)=
;
>
>         printf("Guest mmap at %px:\n", addr);
>         printf("%s\n", addr);
>         printf("\nDone\n");
>
> -----------------

Hi Anthony,

Thanks for continuing to push this forward, and apologies for joining
this discussion late. I am likely missing some context from the
various previous iterations of this feature, but I'd like to throw
another use case into the mix to be considered around the design of
the sharing API.

We are exploring a similar optimization for Android to reduce page
table overhead. In Android, we preload many ELF mappings in the Zygote
process to help application launch times. Since the Zygote model is
fork-but-no-exec, all applications inherit these mappings, which can
result in upwards of 200 MB of redundant page table overhead per
device.

I believe that managing a pseudo-filesystem (msharefs) and mapping via
ioctl during process creation could introduce overhead that impacts
app startup latency. Ideally, child apps shouldn't be aware of this
sharing or need to manage the pseudo-filesystem on their end. To
achieve this "transparent" sharing, I would prefer Khalid's previous
API from his 2022 RFC [1]. By attaching the shared mm directly to the
file's address_space and exposing a MAP_SHARED_PT flag, child apps
could transparently inherit the shared page tables during fork().

Regarding David's and Matthew's discussion on VMA-modifying functions,
I would lean towards the standard VMA manipulating APIs should be
preferred over custom ioctls to preserve transparency for user-space.
Perhaps whether or not these modifications persist across all sharing
processes needs to be configurable? It seems that for database
workloads, having the updates reflected everywhere would be the
desired behavior. In the use case described for Android, we don't want
apps to be able to modify these shared ELF mappings. To handle this,
it's likely we would do something like mseal() the VMAs in the dynamic
loader before forking.

Perhaps we could decouple the core sharing logic from the sharing API
itself? Since the sharing interface seems one of  the main areas where
we don't have a good consensus yet, perhaps we could land the core
sharing logic first. Keeping the core infrastructure generic would
allow it to be used transparently via MAP_SHARED_PT on standard files
(revisiting Khalid's approach), while msharefs could act as a specific
frontend for the database use cases?

[1] https://lore.kernel.org/all/cover.1682453344.git.khalid.aziz@oracle.com=
/

Thanks,
Kalesh

>
> v3:
>   - Based on mm-new as of 2025-08-15
>   - (Fix) When unmapping an msharefs VMA, unlink the shared page tables
>     from the process page table using the new unmap_page_range vm_ops hoo=
k
>     rather than having free_pgtables() skip mshare VMAs (Jann Horn).
>   - (Fix) Keep a reference count on shared PUD pages to prevent UAF when
>     the unmap of objects in the mshare region also frees shared page
>     tables.
>   - (New) Support mapping files and anonymous hugetlb memory in an mshare
>     region.
>   - (New) Implement ownership of mshare regions. The process that
>     creates an mshare region is assigned as the owner. See the patch for
>     details.
>   - (Changed) Undid previous attempt at cgroup support. Cgroup accounting
>     is now directed to the owner process.
>   - (TBD) Support for mmu notifiers is not yet implemented. There are som=
e
>     hurdles to be overcome. Mentioned here because it came up in comments
>     on the v2 series (Jann Horn).
>
> v2:
>   (https://lore.kernel.org/all/20250404021902.48863-1-anthony.yznaga@orac=
le.com/)
>   - Based on mm-unstable as of 2025-04-03 (8ff02705ba8f)
>   - Set mshare size via fallocate or ftruncate instead of MSHAREFS_SET_SI=
ZE.
>     Removed MSHAREFS_SET_SIZE/MSHAREFS_GET_SIZE ioctls. Use stat to get s=
ize.
>     (David H)
>   - Remove spinlock from mshare_data. Initializing the size is protected =
by
>     the inode lock.
>   - Support mapping a single mshare region at different virtual addresses=
.
>   - Support system selection of the start address when mmap'ing an mshare
>     region.
>   - Changed MSHAREFS_CREATE_MAPPING and MSHAREFS_UNMAP to use a byte offs=
et
>     to specify the start of a mapping.
>   - Updated documentation.
>
> v1:
>   (https://lore.kernel.org/linux-mm/20250124235454.84587-1-anthony.yznaga=
@oracle.com/)
>   - Based on mm-unstable mm-hotfixes-stable-2025-01-16-21-11
>   - Use mshare size instead of start address to check if mshare region
>     has been initialized.
>   - Share page tables at PUD level instead of PGD.
>   - Rename vma_is_shared() to vma_is_mshare() (James H / David H)
>   - Introduce and use mmap_read_lock_nested() (Kirill)
>   - Use an mmu notifier to flush all TLBs when updating shared pagetable
>     mappings. (Dave Hansen)
>   - Move logic for finding the shared vma to use to handle a fault from
>     handle_mm_fault() to do_user_addr_fault() because the arch-specific
>     fault handling checks vma flags for access permissions.
>   - Add CONFIG_MSHARE / ARCH_SUPPORTS_MSHARE
>   - Add msharefs_get_unmapped_area()
>   - Implemented vm_ops->unmap_page_range (Kirill)
>   - Update free_pgtables/free_pgd_range to free process pagetable levels
>     but not shared pagetable levels.
>   - A first take at cgroup support
>
> RFC v2 -> v3:
>   - Now based on 6.11-rc5
>   - Addressed many comments from v2.
>   - Simplified filesystem code. Removed refcounting of the
>     shared mm_struct allocated for an mshare file. The mm_struct
>     and the pagetables and mappings it contains are freed when
>     the inode is evicted.
>   - Switched to an ioctl-based interface. Ioctls implemented
>     are used to set and get the start address and size of an
>     mshare region and to map objects into an mshare region
>     (only anon shared memory is supported in this series).
>   - Updated example code
>
> [1] v2: https://lore.kernel.org/linux-mm/cover.1656531090.git.khalid.aziz=
@oracle.com/
>
> RFC v1 -> v2:
>   - Eliminated mshare and mshare_unlink system calls and
>     replaced API with standard mmap and unlink (Based upon
>     v1 patch discussions and LSF/MM discussions)
>   - All fd based API (based upon feedback and suggestions from
>     Andy Lutomirski, Eric Biederman, Kirill and others)
>   - Added a file /sys/fs/mshare/mshare_info to provide
>     alignment and size requirement info (based upon feedback
>     from Dave Hansen, Mark Hemment and discussions at LSF/MM)
>   - Addressed TODOs in v1
>   - Added support for directories in msharefs
>   - Added locks around any time vma is touched (Dave Hansen)
>   - Eliminated the need to point vm_mm in original vmas to the
>     newly synthesized mshare mm
>   - Ensured mmap_read_unlock is called for correct mm in
>     handle_mm_fault (Dave Hansen)
>
> Anthony Yznaga (15):
>   mm/mshare: allocate an mm_struct for msharefs files
>   mm/mshare: add ways to set the size of an mshare region
>   mm/mshare: flush all TLBs when updating PTEs in an mshare range
>   sched/numa: do not scan msharefs vmas
>   mm: add mmap_read_lock_killable_nested()
>   mm: add and use unmap_page_range vm_ops hook
>   mm: introduce PUD page table shared count
>   x86/mm: enable page table sharing
>   mm: create __do_mmap() to take an mm_struct * arg
>   mm: pass the mm in vma_munmap_struct
>   sched/mshare: mshare ownership
>   mm/mshare: Add an ioctl for unmapping objects in an mshare region
>   mm/mshare: support mapping files and anon hugetlb in an mshare region
>   mm/mshare: provide a way to identify an mm as an mshare host mm
>   mm/mshare: charge fault handling allocations to the mshare owner
>
> Khalid Aziz (7):
>   mm: Add msharefs filesystem
>   mm/mshare: pre-populate msharefs with information file
>   mm/mshare: make msharefs writable and support directories
>   mm/mshare: Add a vma flag to indicate an mshare region
>   mm/mshare: Add mmap support
>   mm/mshare: prepare for page table sharing support
>   mm/mshare: Add an ioctl for mapping objects in an mshare region
>
>  Documentation/filesystems/index.rst           |   1 +
>  Documentation/filesystems/msharefs.rst        |  96 ++
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  arch/Kconfig                                  |   3 +
>  arch/x86/Kconfig                              |   1 +
>  arch/x86/mm/fault.c                           |  40 +-
>  include/linux/mm.h                            |  52 +
>  include/linux/mm_types.h                      |  38 +-
>  include/linux/mmap_lock.h                     |   7 +
>  include/linux/mshare.h                        |  25 +
>  include/linux/sched.h                         |   5 +
>  include/trace/events/mmflags.h                |   7 +
>  include/uapi/linux/magic.h                    |   1 +
>  include/uapi/linux/msharefs.h                 |  38 +
>  ipc/shm.c                                     |  17 +
>  kernel/exit.c                                 |   1 +
>  kernel/fork.c                                 |   1 +
>  kernel/sched/fair.c                           |   3 +-
>  mm/Kconfig                                    |  11 +
>  mm/Makefile                                   |   4 +
>  mm/hugetlb.c                                  |  25 +
>  mm/memory.c                                   |  76 +-
>  mm/mmap.c                                     |  10 +-
>  mm/mshare.c                                   | 942 ++++++++++++++++++
>  mm/vma.c                                      |  22 +-
>  mm/vma.h                                      |   3 +-
>  26 files changed, 1385 insertions(+), 45 deletions(-)
>  create mode 100644 Documentation/filesystems/msharefs.rst
>  create mode 100644 include/linux/mshare.h
>  create mode 100644 include/uapi/linux/msharefs.h
>  create mode 100644 mm/mshare.c
>
> --
> 2.47.1
>
>

