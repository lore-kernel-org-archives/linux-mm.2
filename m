Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE1B8CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321448E001C; Mon, 17 Nov 2025 12:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F95D8E0002; Mon, 17 Nov 2025 12:00:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F958E001C; Mon, 17 Nov 2025 12:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DDBD8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:00:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 977EA139AFF
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:00:13 +0000 (UTC)
X-FDA: 84120711906.18.398AB40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C6E2D1C0005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:00:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DXRkM0oz;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763398811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAlaPB0tCEg4Zy+navTIrv3OeeygcARrLMso+2IJFQY=;
	b=i5+nx/c9y0Ckqr8a/cytwkZH9dE4uGyFPmxlI1+15j3FGkze/6TYcprcpjwIf65RVWhm8i
	Dvemlh+DeLvQVPOIYA4yJP3laGPl26Rkyg8Jwh36XFg/aISPNA+A+XzYTzAca7JzJwyywM
	PnriHT7UkUg1Xnzv5pJJVjRf8ddjo34=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DXRkM0oz;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763398811; a=rsa-sha256;
	cv=none;
	b=g4xUmcWiyYuGTcqAZ/NQc4zrJQm+kx4SL1YRMw6L92k1QOLg5SJd1Tj1YHgdNXYRgzUpi6
	LXx+nKRCrFP3iTfGqV+yun200i+9M9w/UxpUoCUjWel8XaWlvyLOqSJalDt3m9R4o6Jpvz
	RLzkVMw3Bp8wAWsdicddDDtznVGxbQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22F806022A;
	Mon, 17 Nov 2025 17:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A21C19423;
	Mon, 17 Nov 2025 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763398810;
	bh=DD5aJ0CYO5FJNOi0XizsUc+cIpf1vb2XlK1BACSazP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DXRkM0ozBdjtfmku47EUoC5aecIc/EhtwKbfV03r6i/hnVF43NpNJqwcS5qsIM4sZ
	 avJzaJxVZPsWIk57vzZFBdJ8qMZwHaZgWPw2J8z1rcKS6opHRvYWcSampBtKJNuyi+
	 8LbTFQqizNyKlp3G/TpTx3az3+xSzmy585HKNQKygHRc95Spvxd4mCuwtv20Ol0uZ9
	 0/W56NbOhupcwU+sCxTDUbL9FQ321StUqwAvFcpMbdKax710y+6ZE+Oz+xrxJ/laew
	 y+8QoolAbRNF4F6Hq9e7TkPvEUMYzfDVNhvgt5o3x+z4NagMG8v7lKnxf7vJF5NP5y
	 rkUHC+7R4jnJw==
Message-ID: <4c5a9201-b2dc-4765-bfc7-f89ec095b629@kernel.org>
Date: Mon, 17 Nov 2025 18:00:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] userfaultfd: move vma_can_userfault out of line
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251117114631.2029447-1-rppt@kernel.org>
 <20251117114631.2029447-2-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251117114631.2029447-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6E2D1C0005
X-Stat-Signature: d1mdy78fjbxchh1taoq8y6nak436cdtu
X-Rspam-User: 
X-HE-Tag: 1763398811-88346
X-HE-Meta: U2FsdGVkX183f6MyidfaGFNGsCzK6737iwHTuVy825W0aT7oIWTCiKioR18yqMSFNcA3/EiXppH663EmJIlX/ylPyqeksLle18Y5cYcieLG3/ZvyCznyenh9n2fL3DrNKadrE/+0Z5XFRIbLhVdJFCEVgwBaqUWQDIeV9/uY2nvMDtDptXl8YI5nGI3dp7kHbBqudQYgpLc54llTFz3HNUfl/6yan9xva462u6KsdZ6etabtZS0jtyFVqMUKZ8v1Jz2pk70JeOuIqNqiEIsNb+xRPA0MvsfpJW5Mm0WefVknIKb8zUbOPwxshvWELimY3slGVLusnIQvabZOMG8N/Z22Wp2nnmMKARsVTuivEz2u/xDNYln+mBGMl9lJw5SaDsMPhN/6e15PCn34zS1BbQy2qMR2o0DqNcX05otOIp7W6UWzD5u+D3wE9MwK5KHwCH09tpnQwMJwpfuyL2FNSfvLQEUbZrK1zDk2wvew24dF1z34mm4X5H9Jz7m3tTMb+fFk/t7XN0/AR0dhaIOCyLGaPYozOSJ5GASeBrAnrv4Pm9ABKIdHqM0NH0CKbYgqtMRpu30ZLVsfX+Yq0G7u2iDmksRCPKAoDEEnE7t1GjDOGQ6nCcmVkEEXjbFX0gj0qv6GrHNwu5gYzksIhKnn9A9dg2jEebZFOJYArZvi1RjSnBeAnR7gjWioRjR/0NT2sc28h2vdpCG7zHBGdpX9PnnGOxAUbSTwhEx1INSpWJW/rTJKSdo3oCVjPytzgPN7eP+zQf63v4sHO9wn6hSAi8l2jslBkb2XWpqsnX8sKUJSo+M2uttB2RkTNcZgqYSnx1pusJ/AbptAR0dQfCpA/Zr8TH06o0dFTA3O5qz5U71enxFTq0K3UFrzRkg+oJ8BJzTa7S5TzhkTw8eKj9QxmO7lKiGWqBqK68VrsxyDM2b2VaIrK+oEOcmLGoL+Tk9eEnt1jflwuJPPLAZ8EbN
 dp8M4o9z
 Lln/2e76sMlOc5Mz9vwpRLh9ViyC7twK0Hp+7odE4iDGTuG0mFSqXcKzQV1X7EgUWXHJUagxAYIogNO8FqS+VX4IAoqNyL2GsD2h5EqGTrD/T1DOAXCJN+bopJA3821uxQcmkwJQfmFgj/roBCstZdhW+37NaSP/VHfII/a0SmW8zPV1bsgA5+2D/5XPeySKhjRSI4rLuQwr0HpiVP6gxWtTZvzSyuvGTZoC+FaoncF81gbM2O+wQ+nKaim/CHQX8V/rZN+7maqZsZjAelnY8IV6BRkhbEh/SRgEFrXzFs1BgtBoQxjgKp+rF5iHtN0Lb3wZl1XuiDxSU/II=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.11.25 12:46, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> vma_can_userfault() has grown pretty big and it's not called on
> performance critical path.
> 
> Move it out of line.
> 
> No functional changes.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

