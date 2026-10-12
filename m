Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724C9CC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64E156B0092; Mon, 12 Oct 2026 14:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625956B0095; Mon, 12 Oct 2026 14:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5148F6B0096; Mon, 12 Oct 2026 14:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 236656B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:21:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC2B61A1265
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:21:10 +0000 (UTC)
X-FDA: 85314791100.19.BFD820F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F029740004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:21:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPUP1ptH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791829269;
	b=CkM0zuFsJutP/Jx9tyfQCCqXRDVCM/3Y0ybIhIyoxlp7TXiplSKMCS+V6b2ChiBSypAG5F
	8hxjRi03rLywf9ikG2oWyqq0lqSKF6AQngqse1q/he+zUJaykPrnDfvwGoGZMVF6Dx5rGi
	MrbgaJ4GPQtrvVvbfMQ+ac2ljneYnDI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPUP1ptH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791829269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHBESK2KlCwsi7XB84TfEpjCQoYTSyYlt8B230e+MvQ=;
	b=FNzvKvf5DwCuI3YuI5wcXWgiPjE4xZdqikPquo8JS6lBRqrfxxFSsEsiHdhYJ8hy9oIeK9
	RQci7PV/4F06MU3kBj/7pa4mpt+MjmvBrxNdkfd3WdZHx4cidNCz7YXsmDMMFYC++UWqfC
	3dFRJGbzJ/JYZyDPLdTQnvkbTMTRURk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0313740B06;
	Mon, 12 Oct 2026 18:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A8A1F0089B;
	Mon, 12 Oct 2026 18:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829267;
	bh=hHBESK2KlCwsi7XB84TfEpjCQoYTSyYlt8B230e+MvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VPUP1ptHnUHORU4MhilrkP5qlYiqZl6uWQDj+FeTap+RZDGyNIOHJBlPuJoyubu2U
	 27BPhvzI7hrw6tlV9qGYW3Bu9xbjOCwoT5tfsKgj5lDpP8wdrsja/bAdDi+YFjySu3
	 IwgvUFFeGgP9UR9jS6daeytrBIIe3ZFrXI1wyOg7/TFojKCyKzv+Adfn2hE4k+wDKl
	 DI3jZ/atSDaAEZmzlmGBncR5yOZWy4taUp3tMoOLjqzqlsy8Z4Gxz7TnELqPvPiA84
	 Sc3daMmrLe9Fxn0SFCfRQ4uacS+2HvI80EDpBY4PxvpLH9W2BkEm1myXJR31ClMRGb
	 4yngVYRbe8aYg==
Date: Mon, 12 Oct 2026 19:20:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 21/38] uprobes: remove VM_IO, set VM_MIXEDMAP for
 mapped kernel pages
Message-ID: <as0k0F_td3WzR8wh@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-21-923b70125b1e@kernel.org>
 <6f71b1b0-8988-4e19-9d4a-ce8a2de8fc63@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f71b1b0-8988-4e19-9d4a-ce8a2de8fc63@kernel.org>
X-Stat-Signature: qn3pigrwrctr9mrh8qtkmhcmoefsadwt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F029740004
X-HE-Tag: 1791829268-293516
X-HE-Meta: U2FsdGVkX19SrSKZJUx2mWGbVl4WLmjOeao42pLftgxK09Wf+oYiQDx+rq/O/Exjhhxo/ck++3EeCJkAfvy+fRrFyBNw6/PTjuimMZaOkETaepL9Bf63MbkxX/LOiz2N9yE7ZXvs4Lul+/nM4V/Wo+/kv+pnWWl7jTXzKHS4tm+vhIs6SaZ7qWiYHfCeFce6Mk3AlrSOw/PAj+LIf0oTl9QWY0SbxFAuAKRGch3OYcZhY7n2beCWGZVSjSchUTbHRlgaXuZsfOQk/nvJhyCFfMXzvlOeQ9DztOFLHJFDTBPmIkojfvAxDQUSiE009LgiroBAtprlIfOjraSqISjtY/CuEeNydILoMBvOWBeOcxFzHUT+NhFiCoy7GTk+KqzD5aAzuErrGnMnejv777x8m4mGkyQtI0nzcfMYi2HIzMB1pxFXW3v8KUoJmao7GNY2AhZplar9TigJ+NY1M5izBpY/4DYokhz6tVxk59WA4Lj+4BQihaqBTEQuUTGVNOB9TbP+LsclhXuBNqzVsycBJrYctvz5hxwQ0ZTB4TBjJaYFEtz4iTttTvkCxBH3GBw6B2XIKZt+XC2kULlFxYolj2bOF97QrRkxNVDYNLHdABvEtFvCatAsrk0QmZlTkLynpdHNloJQKMpPPRrLTlSCngjuo4zYkUPDwbruMq1kbk4hCZRAODQqTdB/8VhBvQOf+sbXzmgGW+lRMMjabdGopLi+aCf/ntYEaCEKZOg2eESpK3VFCz62wjcImBaSXNUj0KJQ2kFOLdVGxQi8idLcZzIW3NKcTy5axXZ9dF9CDDwJAhwlSyk5/YlVxvcunCKsC/IciGgshPKb4nqpvq7NWC/ONL/VCUx4D8Zp1zPEZTqB7Rpz5f77Hf4W7I9fzgTwoBEkgPaYn1CpafFQ9G2WtbQKOlaNrIa6ND/M3qAdwTNfTyzUoDhBFjMqyLiF5ylAJK7apuyzR470E6Ym9V0
 Jw2ynjF9
 zqDLduUFYpe9BQIk070UVfMM8ol3f6P62Ae1WJCwEWMYqhk8LFdzh/EtHZPB34EyC/x46D9YuUen05l7KAefcTXfHjuwKTGcrWQOs2J3RRSjFArZ4olVx4VK9iuveSVgeHV7uTAJRu/Xa1x7zOOmHhner8JmuFoe9tWuQXXMmZzYej+3wmUVew0l1ShFYlPbluhcrkHIvDIrlvsBcxg6wYanvTC43J00c3uxRKjKW14le3x0tTDb5s8hEnziY4SLvr7qGRu/wP+PoTAb0VYiWQBWmjxIwe1g7JzqF5Id2aI2gzal3SHru4y44PuxuGtt4ImOcBJMs26cixMP8OlGXs9xvPyXRvvICJ2TsL3eVSj/LVmcHivA51cJqqY4zC/Bg3REcCOKpx93lxTf4nQ5xgo9r0sCKC95rA9A9+w7ZKhmadfbrIqVitz/SZB99akCcEuj4//z0Tz8bxC95nHaN2Ife2VniLYs5XM9FJITptqD5R1u52fxKDjAyXIc7PX+ITpOBjurhzU2/TpXpggWA1oYsWtsH1zF1Z6guYZPvCmk5mzoWeHMAMdCNzQJaJqcyoMg9MJ+Tnxf2bGNiOkk15OYa9JVPCdwTjoHU/SiBONJiDKA8YgqEoU0YHA27WzdgypXnf5Ezkke9l6n80Lec6kSgj1tPr9Yr/1tDhLSFG1zaX6LNmicJAzZXHb++ocBRWs0x+NGr/ITuSKYjS4UpMeist7B0ywYczNroNiA+WdNepvRO1QHNhDvQrWhYqb2jgGFoUGRD7XWCA7VtajQrRc0vhoUpxWOjQH1O5j8VYs4StxNtA1/Cm3Ey+rGtcS8Nd3AmbMEqp5d48qpoNvrt9z9ZO2/Qs6dap8GdrGTcNrIVTflCynlv0lcitkicm8W84qPd+zed+f4jqibrbVxlZEvggt+iVmgDn1oCBmh9FKA5Dh+qwKkZ0WxyOetpoE1nN+dPr682s37cQuuugwx7rO+yf+ad
 0GGla2MZ
 4siJqgMQBILH+laWdkk8JiB9dTT2EsVgrXoMXiHlwP1C6EmIOQFyL4x24QsKWQYBDk6Ok+HR/k5PMXXkzuWfpGy1VG4Pk+qjR/HwLb9U1BP+QnMTbe6PMyJ+6EUCYRkaqMLjKOWLoQ5IBS+h3IaPh1t2+JCfqJQiSSspiUt630s4n91RLAXzQeZOOfEO7i2rxAdnWfJ7vwBecigBu3+f+Irvpxt55NWsYI564ataZzejKX3fMFdSfIBSiXNNNfRJCbjXyN+FM/qi/ABYGTegnPhZvQlGr2hzEWOXSjzVO/uWxSJaxJSNfB1E917kQF0HZJNyojla8v0nXzuliQrmLncP5PeIU+noRqKVZ6/1pfffsKjuG/67BfW2c1dxW/k3fveXO0PDCEEha1dxITxDNHHlFJW53EmmepjE9RCPZreIIu29OVVy5/EAUhFIy8Vu+jKiMfQ+TFJ4dSuZTclmsu9ydCV2nVf3FTgl2kDmWhvjzuhT3X91s2uRlGkA4mgk57Xm/ntP5pZaAulpmcelxEspqcldyUUaJEr8aEz2FIqVTV0N5XmZR8O06Cr7kR0TQHjttbvM78nejYNmbu7Wonf8hVkIaxb/t5pBMorXSmgZOHgNBUc3nbPMiN2MXIVrNdqvgrAQCLlM+HcWHhm8ozdouoqe6vmm6+P26cqj3hZWjAUe83FsfveJnsUpRhxLkATc70+kQzjOJDQlftD72ndGEcP+nLW2peNbxixur0vClfsbfZUbhnyI7GqHP186nD0zTYdPaBMNtXPz1oT+ZZ2c1WTIaB0FYyrw4a4AHp0pjyZjRpxQfy89aO7hRIldDEJyiNTyeyG5RXF53ZcRsiN+/83B+k1ICKV5fHllLJ9cxXGWWIMsEdCueKQg+kgV8ue6dxJt3pZ60NTZwfNjLvRt1c6kwA5bbUmQG44eLWEu/Ww3pcxteX9eI+exZaPIxFe8J/MJX1mKDLpAvgZHdLlY6y0PO
 +5HRT8vY
 hIOXB09LiLgq8xeI9Qx7g+m8zor2Uvncd+CrYszRZnNzlkoXxGA9P7n3/EsabJF257/ZiMQ2FAhTD09yvsrpb8nuA13Gpj15Fx1cD07UerFEII6XIzrkzv5/gbm8J9SgXMVHHe3GmKk6ZiLMYVN0KqEbjQTLLEfefkkxG0S2A/Nkt37bkUKa1HPqBWeOrfaKpBQJjwSHXImzZchUxMqTOgFz2aQGl9UDiWQ6ZgDcS1jHpaKOl4+C1Nra2E2Ex8HYuoDHZfWxS+unxGdRRvFQdvL06u3BHx04nYqX+CvVXDRHRD5n95dtXVhMYdk7kDfFd7geeIdIztfM8gvh8QUFqlXWSEqtXdPRsVa6EFNeYdqglo957RDQLO9fZQccVxc6d2kpWErEzoA2H/YC1ElEcO4IMUDnengAQVSqTIxwddXf15GIk3Yote58be3vp3cvq7Da/Z+yAwK4b2QauUQwIKFeELZe4VrmdBZbTR492bxpVHGDGwOj2djhyXkMzsVB1Or0wB40LikkHgTIL82ZykX1cP14zxp27AEyln90EyGnAjHeUODgAcpLaHM39IfJLCm9NEAhK0umvdxyVW1Krcga/Y2YM8TQW8fL4aBGfrhfDb+AI+e75rEWSkMiYmY9K8jvuas2960cIaH6aWUX2arIcc0x3tTasNuAi7PgTZL0Y87CUyqJaz/7mBMTW/mRd74OO7/F3kAoD331jO5ksm5gEqAeEKia3Wxs8cOx3iazrfWVpgp8Dn9jEXViNeX1yFec2mPQPCLRHFElZhj+9tLudD2xvhF8BWBlG2Lc5VKKQn89ToGw2ChEYZUqmEiaqygJLW3VfHAq/P6tesJsQFodPOFqDmFetag0PyeCqgrD732lVDWbLoeI9s2qrFYez8vMDgjhu6gQX1f4TO36kysz9fHTH1XclfjXrN3LmX+PdgaEVoxWW2o/o2InkgZ6C0Q4FOYKAourj01saaELiJFb6l0LZ
 tM9AJ/Zj
 YXmcxlg+eObCJGNEsy2A6mw3r0HOxtCMzCqSF2WYJqNCDKMD3z5Z2NxuIeEUS7Xf9wjkWJxWoLQC0myv55Taz3BvKBLP0DF1t3R8cI5iyH7bAsbyhVfBGYOj10RZq/oFJb3H6KI21n5vea635pkqlE9NShWHKGgC3TpAkoz1xSTnqaYTo5VN8bnyv8TEXUmGPQtPs/c1GwbOLCEcBC8k6W/mhtCUb7DGuXboYbzwCMNs/tgA+pE3e5kHaClCV5T/DDipVUoLon74lxkfPHbeuM4twmreYspe3IdKMX7FVq4OzCSie3/MK3qgQs4yyOfZOJZvSSfwyv4vNH5K9/BdtVUe2zEiAxPvQ3wP6Ppz/PwyH5PjIrS74FIHFQEX6PxK0VzaDQp7oRKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:16:56PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.
> >
> > Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
> > the appropriate flag to set for those.
> >
> > This provides the semantics required - no VMA merging is permitted, but
> > does not prevent GUP.
> >
> > However this has no meaningful impact as these are refcounted and thus can
> > be GUPed.
> >
> > A previous commit already prevented __mm_populate() from being invoked on
> > XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is no
> > longer required.
> >
> > Both VMAs set a VMA name, so always_dump_vma() returns true before
> > vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
> > in core dump behaviour.
> >
> > Change this for both the core xol_add_vma() function and the x86-specific
> > get_uprobe_trampoline() function.
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  arch/x86/kernel/uprobes.c | 2 +-
> >  kernel/events/uprobes.c   | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> > index 65a2de82ecd2..0f60c0d076b6 100644
> > --- a/arch/x86/kernel/uprobes.c
> > +++ b/arch/x86/kernel/uprobes.c
> > @@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
> >
> >  	*new_mapping = true;
> >  	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
> > -				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
> > +				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_MIXEDMAP,
> >  				&tramp_mapping);
>
> So these can now be GUP'ed. Let's hope that's fine ;)

Yeah the commit message mentions that. Since they're refcounted I don't think
there's any problem.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

