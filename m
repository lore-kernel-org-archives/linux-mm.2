Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F276CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D7D900082; Wed, 13 Aug 2025 09:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDFB900044; Wed, 13 Aug 2025 09:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FACA900082; Wed, 13 Aug 2025 09:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 92FB3900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:53:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 447AC11707A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:53:35 +0000 (UTC)
X-FDA: 83771876790.14.214504C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 566E54000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:53:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="2b/I8Q8C";
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdcUPdOGb/itouYdezLP0qbkh/IQMKN2lChnwBugjFI=;
	b=g/LUb+B9/KNDHyLFUZRHi5Pw2nL3qNTgrUZ+s+X1jtiGaZROU25MLXy6tjeldQyeg5jEsS
	/Pog1WypjA8nmvGNSIfkMy11cf15h4Lz0zWWUCN7HgbtEcYN0cMXFl9u6U1NNLJkJ0eLWr
	+ssv8q6ZJK4+ugVfQ0mET85iG7Qx0Lc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="2b/I8Q8C";
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093213; a=rsa-sha256;
	cv=none;
	b=Vom2hXzXWr4VmhiqXvgBNxuXd4DyL0+IfsnXQNQS8mdvUOVJB3bjl/PsYjM16+HXC7APUv
	wCK6eGstneGynjoByMG2i1MKQGFiotJa13frdLTXio+nY8Fw0EsBkVA6arZRL7r8kaLUwF
	jnCjDt0dN9P2e3x/UcdbKcTCuwuOTO0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B1B54541F;
	Wed, 13 Aug 2025 13:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EA6C4CEEB;
	Wed, 13 Aug 2025 13:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755093212;
	bh=2ZfkxvrE9evhAuNxUgTtfyeiBUjNsjnmB4p7ADpVvL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2b/I8Q8CtrPTb9BsmMkVcw4Xk5xZ+oMPIBMOH5Ta9weUZ+2KnKkWk7qgi2m4uCduj
	 WjJ//hLYdGC8LtH/h9D7XDYUGmxoF8P2lrecXPH2EHat2C7eRwX8Y4UFcHDH/LxUPf
	 o38cQmCkR1Y2kcyKbUMjSZhbFEAx8hiFx9X/LXOI=
Date: Wed, 13 Aug 2025 15:53:28 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Vipin Sharma <vipinsh@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <2025081338-dingo-oyster-bbbb@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250813063407.GA3182745.vipinsh@google.com>
 <2025081310-custodian-ashamed-3104@gregkh>
 <mafs01ppfxwe8.fsf@kernel.org>
 <2025081351-tinsel-sprinkler-af77@gregkh>
 <20250813124140.GA699432@nvidia.com>
 <2025081334-rotten-visible-517a@gregkh>
 <mafs07bz7wdfk.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs07bz7wdfk.fsf@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 566E54000B
X-Stat-Signature: s693eatpy4srxtah5ynq9jy6myi5xi6d
X-Rspam-User: 
X-HE-Tag: 1755093213-89435
X-HE-Meta: U2FsdGVkX19BeXhrKWAfkj7YiQzDyDhTOln3B35a3gjQYIHpwNCbWulYBogWWdk3l073PSOrs9VE08O4Vltw9wB8FAikS+n4WQW/MNDGMCwr86bafL7WlecFir8XnU3eb+nJozaYYB5o9HPZg7r2xGr9yXPKrLvM/xG7dVDa14DxEuoea7WYOyXALedpNdGHb59RnRHg9d8Lzgtk4HKGuVpjjF6ezdkRutyD0NdUQxsvi1y9sc8OqayFcFI/b3PB4MCsAy1/vdX2Kdl75Vga4QQbxGtulfgkOoaNDt9RTsV8FmSNtXly+gsqmy0NphF16k/OPixopx+SRdpbmrLbL+wRBRT8oXGm5E430a6u/ZQcl85RNIrUB12hO9pEOlkP5h5PnnZIZMJOpGkpOsu9E+Ufy168JyKjEh/Cw5BEUUtZpI9O0mefz1nwaXZ/GcgrTi6G4Z8DxLkiMzZ0obrKCRUyxZ9izzmU0QE5bMW4kyZ9/P2XWq+oH1gcIUr17cTCCEALjT2NEMmYj02GLqNhUV+ELuqJH08IpRhpFdiuQp5uAMTl2aylJg4NbDUUFOrLdS4yzw9ZUEIFZDcayYVjSmw9U0VoP1cxlc9hiWAzHgtQt60MVlX3yQdSjBmqjDBY1exE58bI+jVidFS9InNQdCSfjTrjocSe+ovOBxmzMV4YTUJhxKTbPJfTp2Nv+okf+jaI4s5ax4Xlh7LD7hyHPnhSDJ4URWJPm4SJK2debxNexI15ZLdM+QF3JONmKe6lHXnNTf3vxP5JGFiSghjBmsngYLLADVYkrm9p2s+SBXGn4NlWdv0Cc3W5Ek11j765ku9I1D4tBCNI7Aj2612ziZLIgdU36yuNUodgsONifba4Ga3A4Hx0kpHjMonCLwyXvNmwcUb4B3cwKXIXJryIL7cTK7scNZDStVhNhqieivcFn5E7Qb5ZoDW42t+NXcLcmxCOnKpe/dvFtCzoQyl
 9MWBTcEY
 veevI0JFg97OScEIjeIDK4xDYdf2oB26ouHRJBUIvVzhC5WQSHZJVTVj3NnaWYMDEZWgSzg5J5yakhf4LDqNEXHPKEn4GdncWgDd9JbqLiaiUzoZWLDgjjnNbz17pua2+utWcm1Px07NTBfTleDMNDgK4/yleRdX8o53EUw60K52N1NqDH/3agTq/iJjm42bjrBE59SlfqMIpgHU90OBHKDpvGMtvXHCH6+4G+Eq3DApsFZBJtrMP29lh5aweqeFPEIAGLk8Yexpst+o7EvyLWiLV+D73Xly5QO9CMj1kfis2tO0ouIihYAzSNkysrHNGm9r9GnPHd/Xr+PA2XOr/lzlc2CTsi7Qdq7q6zfZ0weJz0E05grGUgaAP6vmDmsrNU/Aa29geAlz5pimJgrDzC/ohGjFMqEUP5SYhVJnXBXdSh6W897Pht6OlWzCfsC1VrKgV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 03:37:03PM +0200, Pratyush Yadav wrote:
> On Wed, Aug 13 2025, Greg KH wrote:
> 
> > On Wed, Aug 13, 2025 at 09:41:40AM -0300, Jason Gunthorpe wrote:
> [...]
> >> Use the warn ons. Make sure they can't be triggered by userspace. Use
> >> them to detect corruption/malfunction in the kernel.
> >> 
> >> In this case if kho_unpreserve_folio() fails in this call chain it
> >> means some error unwind is wrongly happening out of sequence, and we
> >> are now forced to leak memory. Unwind is not something that userspace
> >> should be controlling, so of course we want a WARN_ON here.
> >
> > "should be" is the key here.  And it's not obvious from this patch if
> > that's true or not, which is why I mentioned it.
> >
> > I will keep bringing this up, given the HUGE number of CVEs I keep
> > assigning each week for when userspace hits WARN_ON() calls until that
> > flow starts to die out either because we don't keep adding new calls, OR
> > we finally fix them all.  Both would be good...
> 
> Out of curiosity, why is hitting a WARN_ON() considered a vulnerability?
> I'd guess one reason is overwhelming system console which can cause a
> denial of service, but what about WARN_ON_ONCE() or WARN_RATELIMIT()?

If panic_on_warn is set, this will cause the machine to crash/reboot,
which is considered a "vulnerability" by the CVE.org definition.  If a
user can trigger this, it gets a CVE assigned to it.

hope this helps,

greg k-h

