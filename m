Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83111CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD4F8E000F; Wed,  5 Nov 2025 11:28:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4628E0005; Wed,  5 Nov 2025 11:28:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12058E000F; Wed,  5 Nov 2025 11:28:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE49F8E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:28:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91E2F4B1BB
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:28:15 +0000 (UTC)
X-FDA: 84077085750.24.764E350
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E4036180011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:28:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EVPncHIh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762360094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tx9lswogNRQ0TZt9WL0Qi02NOUSoFXBUIWfnFP8NGzs=;
	b=gd1rvVoB/r+K1fN+zDaJ3OY30afShcok0jnWb00LiO4L+LJo9wd2wcT5BE2DW+D5xZeFkj
	r5kkL/8UwGIk1XZJy3NkYG/8p1Qo2030AYKAGfzwjni30iq5YQT9e9Ek9uRrPne3I/REh1
	9lolPRTYx1khVATzJKCimMB8PN1KIT8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762360094; a=rsa-sha256;
	cv=none;
	b=aGc93yPdvJL0r/Dfki7x923B+wylkCnG9+G8XarrVLz7G05iY8Q3BiFiPPJqoISmJsg2q4
	CrnhKrNgZ+1YSR69KYoNlgQkkfHVIrI4v2tuoHg5qbOL7ZlnOdsHL5CUIZRHS3Dj8lSFmM
	mQsKXD+WYKwIX5sRkTPDmwljT+VVdRw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EVPncHIh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 026AA60207;
	Wed,  5 Nov 2025 16:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33848C4CEF8;
	Wed,  5 Nov 2025 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762360092;
	bh=XZsR+JyD+p+0AmVN0UT/SExpbSqoB4WWhXwZyYv1juM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EVPncHIh/EOqGFCdREjl+2w+VGlqkjCAARlMMggMBvZaXK8WL0I7nOF5N4aUy12Cq
	 1MSijhgS4t1291bQKTZV13FU2rRXBsTAO6sw3VIanGxLl45tXeypLZpfH9cBgrprC5
	 fM1xwVaxJiZq6874ZxPd6vM4+G2lil3Imv1yectPVArs+70jgStj+MFd3Ah71oFg6O
	 zr7opLT5qYj/5SwzNxTtzqY28hyfZ5N9A4zxq7eSVVstrYiRaE1amTmjR9YabuZCi8
	 h9RLNiMmdI08k8CXbIE1EcfMEPVNt1U4TNNFRL6y1/AssFAz50F6+TmhCRxSGER9yX
	 s9v6wleyskP0A==
Date: Wed, 5 Nov 2025 17:28:10 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 16/33] PCI: Flush PCI probe workqueue on cpuset isolated
 partition change
Message-ID: <aQt7Gg3XJ7fVdD3W@localhost.localdomain>
References: <20251013203146.10162-17-frederic@kernel.org>
 <20251014205034.GA906667@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251014205034.GA906667@bhelgaas>
X-Stat-Signature: 8xgtbes7ik83piqea84a4qyrrzgmtwe1
X-Rspam-User: 
X-Rspamd-Queue-Id: E4036180011
X-Rspamd-Server: rspam10
X-HE-Tag: 1762360093-435692
X-HE-Meta: U2FsdGVkX1/RD08GCVqaVk3wjJT96rFsFBAd5ZB7F8dWb6Jq320TJfRU/VeqRZXSVZli6QwDU7xDFTPC1LChH7metric+fVgQ9NHD/nY2RXkILXnxvczfo5jOZyxcz+kwvt829MPs4ibWInD7SjkWBzxpDy2MWxJdIQkcEZGIC70vTRMzGmYyz+Di5fW+M4hDWufp6Yxef8d9bAarEOrfHtNyxkE1FrNK6bV/REx4CVfbm9cXnEWGhriGNHPPs2QcbsNT69V+Sn8V6N91ZS1LRNBqknwyUkOExzZPXaTIbjmKme0l8zwVxKS+7aSxftHa14W5rE21cp6db2fQ6J8O6mPrgH/uZONevIQfv4lFsWt+22eDpgn9tZgLGaF1J6r5FV05mHpwPPovzGpq9hJ7Ui9ObjKhAf2UbcqundrgG2ivUjr8VhXC6FsmlN8H6mBEaraTBABAVjBoLT70tnvPzu4N5wQZClGtzD6vaGjJ/XnCv4tvRUFxvAZIvqBCrSEDRT81hxmjCEG4Qk73EDw5LRoaoRYe2B+fQs2RLVptO5IGqQh6xC5xFmlgScbY7vefMNpFHuo3a+OfYwAUeb7bXmxKaVRtMalN6qD7FtLNtiyP1qK+OayIFHbrV0b3cxwtokQuDw+TbtMUWNj7IHkt/e65A/VAtFM1G4s8+YoBQdUZh/LCROzy0+KbAECLfzDFHf3AilCUdymq6pPFZcX+3LLvF0DJcjt8uAUZ6CHpGdYU+dq3ddPKj58leyEOnaWp2jAO5IotfyQln8MuME3p/+b4xt0Lx4qs7MseUbVFkk1Mw7kGaNPNmeAjhmn+ZI4GH/WSJJ77jIf6eZ0kDzv/zGwSNDAfTV91sT2lAZHDlmF+QPohMLAULuL/jMHvGijo8wShuEZ7ChxCIR9uXPBfysbpB9SriJ0PX5BYuU3Ah47iEa4RTMDFZtZWPw4BcRHZi6FkSyrUt5a5bljmZ8
 u6Ppdo1L
 8XAz3B+rf+rwUUjpa2hn/tM4Uwl1/gqZEV4HyuwkmSV9asPiOjcCEICpKldWiz8v6UJexvR0SYyRDzcJl/+u6ByRK8GkKENfGWHXMNfDVsjVThN88LE9X6H0Z4MFejLUq31Ky3qk7hbPDtYAlWAeM8Iz6PNSqrz0c3t75mT7nv5scoghVhIxqWCXzGZX/3phFPjQprMQ5v+ByPeRwwn9wOl6bh5TIlrZCnugNK6UH72gJvrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 14, 2025 at 03:50:34PM -0500, Bjorn Helgaas a écrit :
> On Mon, Oct 13, 2025 at 10:31:29PM +0200, Frederic Weisbecker wrote:
> > The HK_TYPE_DOMAIN housekeeping cpumask is now modifyable at runtime. In
> > order to synchronize against PCI probe works and make sure that no
> > asynchronous probing is still pending or executing on a newly made
> > isolated CPU, the housekeeping susbsystem must flush the PCI probe
> > works.
> > 
> > However the PCI probe works can't be flushed easily since they are
> > queued to the main per-CPU workqueue pool.
> > 
> > Solve this with creating a PCI probe specific pool and provide and use
> > the appropriate flushing API.
> 
> s/modifyable/modifiable/
> s/newly made isolated/newly isolated/
> s/susbsystem/subsystem/
> s/PCI probe specific pool/PCI probe-specific pool/

All fixed! Thanks.


-- 
Frederic Weisbecker
SUSE Labs

