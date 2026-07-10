Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB44DC44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 22:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8022F6B00C7; Fri, 10 Jul 2026 18:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B39C6B00C9; Fri, 10 Jul 2026 18:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4606B00CA; Fri, 10 Jul 2026 18:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 442E66B00C7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:11:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC68B1205E5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:11:55 +0000 (UTC)
X-FDA: 84974265390.27.4F0E139
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id F133A140005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:11:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=isSd+YdI;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783721514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJbMePxYpylcp4oMY5TEvTIXxy0y15lVec2d7nGNr/0=;
	b=o4zY4N/NJSnjUK3xGQJRE7jykVwORwp+VFXd3AJwhT0q6MaxzhwZDsLV2X+3ydejjKsVg2
	na1Z3FjrGinGFdFTMhXfNJloVSYVKInL3Sk24V4a1gtnknCpKs61qPrnjPvCQqRoen4/8D
	vyDujn2l1nMLUp/yoGil3Opz7voh58k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=isSd+YdI;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783721514;
	b=DHRvcjDNe3Hq1QMWQqVN871WP5zQDXbpNkscGOOVVJjUj16zQO08qba/hFEwx29nZejIxm
	XIpE0Jpg+0yDcsKjhtGJ2wV0BkaS6DUZ130q67foBxYEEAxbZn5ctJ8JRdPpEXCOtyaHnl
	Ai2Wtj+eD8XhAbaFrmxACKUxzNmDvVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3C1341453;
	Fri, 10 Jul 2026 22:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABEA1F000E9;
	Fri, 10 Jul 2026 22:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721512;
	bh=vJbMePxYpylcp4oMY5TEvTIXxy0y15lVec2d7nGNr/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=isSd+YdIk2oKRkj18Y+rPxVD68aDvGRkC3Gfz17Do9Znb6noKkhNVD6qZ2vomkJnV
	 Vz3mMRKNl/P1Rv/PJH445qJc6+MsAE7TmU46muPg/2k1wbFohRwIe8WbSdXx1BmEdU
	 TG5W4PVDlLUdPHejARtAkCr9JonW/gFOE5KBW7kI=
Date: Fri, 10 Jul 2026 15:11:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F133A140005
X-Stat-Signature: acp7awf8gx6o9u13338caykzi1wwiuaf
X-HE-Tag: 1783721513-828155
X-HE-Meta: U2FsdGVkX18Fv8kkIIl85AKReOwwUIHyJrowV+OG1LTcHERpXxuLuUOAtEDQubtjyjcTNS/Yikt7YLv2tFTe0tmXyLk/Xl8sn0VZ2KoXiSRknMAwbIDPPN82e8dmMuaBIYn7pUw0SrvDu0FVTqBiD2juhe+DFR0Mqlk7V6A7/6MCiTIHpL2idMz13QM2X5iyVU0lHWIg2rV3Z5KvQrcXcm3jItk7mYih0jAKihWv3YrrtQTRJVbCGaDVXSFuT/7qBwZf/Iu+FEuMqDpBtdIKaCbe77JLdWjRTuxg52f3D91rHkc5pTGUQ7pkTQoiBDXDVpDuoSC1P2g+FSalBcc4nS6XYztXeuyjs04UuROBH6DI6Iv3091Sf8TQ+MKrZI5EfmF3Ij67FCUFIrjZG4iy0eAV524iMiKYs1LdpC/VOsYbth6PM50zNB+D3/UnPt/GjP7p5ByFXdmx149uRINeYVn7XivKN/iGm6v7jcnb/VN0O0NUkKZvDNdvOQZfe8yWHsjZ3Vpp33obhaoU+KrmCSef3LMg5EIJwkncy7IrXC8VXDKnaKbSMzKaoVFFyxKhWEgkfPQyK3/Ktnt0ReboW3KRFf1R5T0L1JfXLSfGqS7lMZZkkQd//kHgvgSAzrVHfnyIeBUFSMFd/qPTjK5DpZYRG2fsRh6d+sH4mzv3ZN3kZ7ejDq8C0SRIad/+noLstRceNufbSJiNfD68jdaMaD1yGyRmelLW1v3DPepySbphZeqyPvTtDGV/WIth4304RL8DmetLh1XNrnmZS9drrOtDf+h6y+gi1oHgkDdY6HO94qIcNlSz9GswO1jvFchhLCp4U+eJXDM581nx5AkokbqdIFX4VBQfdkx0sTLwneuW9fewABRY+WOSBrVYO8Lf6U7XAvBcNzoKkbRwTAqodYBednr7AZgdX5XEyMrJYBvkFLhFyjFuuHZylPGEEjz+WLTZt2xrlkuLZVMGPHl
 M+/mjt1M
 omnKnhqG/cqDC6C2De1szIuZ2BbL1AGhZEUM7TLQ0l7QDrK2dBneHVUboyOWAbA2DWCP8GhirVNrOZUlp4bv8bnhrOHTenOBv/m/r0ddmiUNRiXlsd1voH38oSY/J+Sl+OB3Re91sV92CoM57rn2PjilrCVWoW5EKI79uPrbaNrGQRYxem3ru8vZHOdA2NF4Fp8DqX/QrOAgumtt4bqbyMknTEY6mt7+b43FbOV49tEQ3n5Nx9ei8Zl+9Ef/uTOA7yU3QCS/9Xs5pjp8HHddW9rRXgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 14:26:20 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().

Thanks.  This seems fairly mature and mostly-reviewed so I'll give it a
spin in mm.git's mm-new branch.

Unfortunately Sashiko wasn't able to apply this or v7.  I'm not sure
what base you were using.  Hopefully there's a reason for a v9 so we
can retry this.

I have a few niggles, nothing major...

