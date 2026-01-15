Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFE8D4661E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E556B00C9; Thu, 15 Jan 2026 14:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0ECF6B00CB; Thu, 15 Jan 2026 14:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A090E6B00CC; Thu, 15 Jan 2026 14:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 822536B00C9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4652F13AD7A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:28 +0000 (UTC)
X-FDA: 84335207376.17.D6B7B88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6CD42A0009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HFbrkaxb;
	spf=pass (imf15.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZT+o0VjsIJqvL4Ye1+Mojw1LAugYAMc89Qw5GYzSAw=;
	b=mqbxwnIbiwnSFBnYEYie82oDfodDiXMoRsegKmgtTPM4BadTPVRBBZjoFiPHNvc/+k706G
	SxoxCcndzkctSyk4VJfJy2Mkfn+Hue3IXpD42qmhNnJ8uSG7aZ7EVa66ZNNkzv2Vsc0jqa
	ylGXXZFJ6ze5SaRp5baCJvs1iLCRYJA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HFbrkaxb;
	spf=pass (imf15.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768505846; a=rsa-sha256;
	cv=none;
	b=6sclQCb33IK1Sw0tQuF7nEpfWPCjSnBpv73oixzzUUtk/eGbAuhQYT38rlGD/9NPdd0lAG
	5MC8Yo3DgkolmCHyz32GNipprZesflfXfyNkLI44QIZj+0hrHuah88H+XTHt9rZUxUMTAu
	SshidvJFeRrXwKXDcnKUQedYDIhRjVM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B2A14443E;
	Thu, 15 Jan 2026 19:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB8DC116D0;
	Thu, 15 Jan 2026 19:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768505845;
	bh=WJfdSxntdjCGN+SFF94mp89xagtZVsc8ko5YpfyHmzo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HFbrkaxb1G2AMG3MzNBQW/L4EalwCCXCDDxxDQ0j51u/B6PgVvK4NDRP+gGsVfnpe
	 VyaIgHktK2ed+mNcElWfMOvW8ETWuYtZ5BFV7xemUUxHpfR8cVtiKroue7/9G/qCGd
	 rt85fYelVNLihiQeGcg1jxPrf/3yQwBY4s+8zZk5LgZv0Ho8j42Klxvmo6vU2q3pOQ
	 ev3GcW+Npw86laMA3/1Ho9Pk9tnCRdwq68XKqMY+ib2uyFDvs9SuOLSNploZHBt1DR
	 d0vpBTEHYbunJ8ienXua5qZh3TfRauncM885fsO/Gz1dFmAlUhHctfiqlwv2dV0p89
	 QAbmFxgjt0yHA==
Message-ID: <4d9967cc-a454-46cf-909b-b8ab2d18358d@kernel.org>
Date: Thu, 15 Jan 2026 14:37:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>,
 Salah Triki <salah.triki@gmail.com>,
 Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
 Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org,
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
 <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
From: Chuck Lever <cel@kernel.org>
Content-Language: en-US
Organization: kernel.org
In-Reply-To: <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6CD42A0009
X-Stat-Signature: 6pxdrjrktatmb7w7jk1x96ppsnckhwz8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768505846-434578
X-HE-Meta: U2FsdGVkX1/YbTx/XNxQzhpNe/SPTeUTgi1/sf4NOV9DZthAmCmBFx742BET0/fgzH0AIuk+kBdMAbZE+mgbqYXcgQLTC7Z2NOE5YZN59rzLBrGwdDLFPE+c9CdVkKbnLaUWKAeZs7ZrgLcEwUUbupBD9ItZJtAc/Zzt91JR+8PtAV4PyLAOcL09F9e6lt6yy/Lr4a9HYDODI53MHHQ+Fm1czm2FGWsewVL3+0LeBF857KuefnLtJtGNdoOwKwbcVXdpavI9N6yY00kSVfJHzcbaGHhvIfLdMx5tYyh0Gihq9daG0FMvCEr96Vumvsqo9RHoORnCLstUfGrnamNCbrZdIYtl9k6vFY1I0SZk9Ff0BjnS/hPuQ68HRkR8yTN30ZYAqvul5u0Ugqhk4zoY08mtsmlqBbp+ZT/3JHfFBMgtUCpjTd/bOKvgWZ+06vtO619Rjm0Z1aGONYitJwn8S12Nv8Me6mZTrcM3yAcYOP5JBPDm3/adLUmN0I6bd37uCUX0oJhs4C/aErsA5CRFp1EKFYIUhpF69VIQBMGy3X7DZaupwgkWk7JHNxpbgLYu/G+AuWq3T/sXRqjg8FC310e/AOwpk3jITdBF06JWcnCRsgM6dOwF+5MevT703JzYP7xFLF/4f1c4RXEP3ZbwmQLqoMWtZ8aq2jhqqK2F+riR2hv6ndcYnRk1bKaxmhogJsBWHkMeXZyBqfyKnsMAW4g2ifGeV7FXnosN/gGC1eM2d368VLcv5SfijejbAp9RQz+rGepe6ffWa1EmymanGlVr3HZKuTPE/E2xGBvWCgj6C/3kmxhGwx/uFXv4HBNAIKbHQT2vmEjWLwSmAnTXzcG0d5SMp+NNUrUH15txD/9CtssgXPWv75PoOsiILYsM0V96chxCZARG5ehq9fUBxmwthOOxJcALEixhbKRb3+eI300RKyKW/CEyrany41jziSiytn9mKLQ3KUesIY9
 PwxgCYfc
 Pz4pUWiR04Yp53LFxi8NFZST2jXvVkQgSbAE1EzqtVKyV4WsiVBrL6Nyjul9vsgmM2TRk2mMywIk/wJhO72FsNdFjsHxuCAXn8Bas2ve2ph2vwBDnjPu33iQLZ4zsv4NU6APxRvrMPIsFwa+QzEUYdNCymBH+10+JyOpA89tztZCm/trafGJf4/WEPRaCz/nxL0Yc6+AtHC2bzvNj8SyWBbFqm+GtokT/nq+lInIhc0EZM23YXGvsdcoiiPSNIFngIiCPNsfg6L7XklnIEcp/CKkgcvmbKO9R7bMT8gSVXvVFQyT/4dVe8/IS4lqtujI/adtrs3R95YStVg8prz35UADfyd2fgerLNNg8S8WQnvuDXl2eXORQNmEuHPwTDh+U2aWB9knNpN7AlAg6U7Fvv++W7eafqx5sgs9s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 2:14 PM, Amir Goldstein wrote:
> On Thu, Jan 15, 2026 at 7:32 PM Chuck Lever <cel@kernel.org> wrote:
>>
>>
>>
>> On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote:
>>> On Thu, Jan 15, 2026 at 6:48 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>>
>>>> In recent years, a number of filesystems that can't present stable
>>>> filehandles have grown struct export_operations. They've mostly done
>>>> this for local use-cases (enabling open_by_handle_at() and the like).
>>>> Unfortunately, having export_operations is generally sufficient to make
>>>> a filesystem be considered exportable via nfsd, but that requires that
>>>> the server present stable filehandles.
>>>
>>> Where does the term "stable file handles" come from? and what does it mean?
>>> Why not "persistent handles", which is described in NFS and SMB specs?
>>>
>>> Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
>>> by both Christoph and Christian:
>>>
>>> https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93c00c@brauner/
>>>
>>> Am I missing anything?
>>
>> PERSISTENT generally implies that the file handle is saved on
>> persistent storage. This is not true of tmpfs.
> 
> That's one way of interpreting "persistent".
> Another way is "continuing to exist or occur over a prolonged period."
> which works well for tmpfs that is mounted for a long time.

I think we can be a lot more precise about the guarantee: The file
handle does not change for the life of the inode it represents. It
has nothing to do with whether the file system is mounted.


> But I am confused, because I went looking for where Jeff said that
> you suggested stable file handles and this is what I found that you wrote:
> 
> "tmpfs filehandles align quite well with the traditional definition
>  of persistent filehandles. tmpfs filehandles live as long as tmpfs files do,
>  and that is all that is required to be considered "persistent".

I changed my mind about the name, and I let Jeff know that privately
when he asked me to look at these patches this morning.


>> The use of "stable" means that the file handle is stable for
>> the life of the file. This /is/ true of tmpfs.
> 
> I can live with STABLE_HANDLES I don't mind as much,
> I understand what it means, but the definition above is invented,
> whereas the term persistent handles is well known and well defined.

Another reason not to adopt the same terminology as NFS is that
someone might come along and implement NFSv4's VOLATILE file
handles in Linux, and then say "OK, /now/ can we export cgroupfs?"
And then Linux will be stuck with overloaded terminology and we'll
still want to say "NO, NFS doesn't support cgroupfs".

Just a random thought.


-- 
Chuck Lever

