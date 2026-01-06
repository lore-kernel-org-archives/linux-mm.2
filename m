Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B9C9CEFCE6
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BD56B0005; Tue,  6 Jan 2026 13:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09CB6B0092; Tue,  6 Jan 2026 13:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A083C6B0093; Tue,  6 Jan 2026 13:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE316B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:12:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36454160773
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:12:53 +0000 (UTC)
X-FDA: 84302335026.23.479BD5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7626A80003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:12:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SvvJMHY8;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767723171; a=rsa-sha256;
	cv=none;
	b=GoRnPAjZ6VDfTQqufEsh9XfBeInyL1B6/H8riSyQRNkJAI86YP66ub5+/hwRALE7vERIY4
	GZSGhVoDcs/5IKg7PYYV1lhMoxqli6thZ0gGBAHxH7G/tIG3oBwd/1sl3/Q44cQVqtpkqh
	pmbhBX9YIaX6tHZvGlK94/EVKDsjj98=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SvvJMHY8;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767723171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdPnVYiKjCtrY/3M3c2nKgQWyqFLtw78DacgPptnGFE=;
	b=YHGwSkqeLDU2aRUguarf5olMrwRdcRV9eDbGfyrfjBDhphn6fHqisXDKBqAyQFRkrQ8gF1
	6BS5z+8W1WEuZAn5Qzo7/xxM9enWD71ypolD9gHi1DZZ/ODCxnciYXZMuhX74ktNYL/XJ4
	new56RzvewXHT7drAAiEMlJOuT3QKzc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BF84434FE;
	Tue,  6 Jan 2026 18:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBA7C116C6;
	Tue,  6 Jan 2026 18:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767723170;
	bh=7RWo5kCkraUDoq57VjbK3vtHJlUViu8hMIUnWPNU4PE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SvvJMHY8GZvf0rhRiXF+ngUuo5JoM8fBXf3Mn3NQVKG/YTyBOx4qR/KZkfGW+NO8K
	 WK6XyJ4hwj+Aqy0mqisS4E5WMj9n6t2X1M7+en2gOWlIfFbyd7MqdRZ2yhaGsJkI5B
	 QOWcpPmayIYNzA8ljDv0/REstaGB+lb4rQkxZdN4=
Date: Tue, 6 Jan 2026 10:12:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, Mikulas Patocka
 <mpatocka@redhat.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, David Hildenbrand <david@redhat.com>,
 amd-gfx@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-Id: <20260106101249.be7514e75c09a928c6fa71ef@linux-foundation.org>
In-Reply-To: <61c3d41d-602d-4dfc-872a-873acf653b6d@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
	<61c3d41d-602d-4dfc-872a-873acf653b6d@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7626A80003
X-Rspamd-Server: rspam04
X-Stat-Signature: x3a76ifjeuz9ia7xm8wggf14hauxp44q
X-HE-Tag: 1767723171-209572
X-HE-Meta: U2FsdGVkX1+NirX6AEbS1dIXlckJLhlAm9zQzro9vuP+1AySUMb8QQpVa21zvyPV2gvm69tIQgQTES0RvrHa1pqxd3LfnBXYBhiyPmohVoWsElG36/qKEt7JjCelxyaNz2TrxgMQxJSaDiuASSANicefpOGxLU0FgIqAqcgLSqNRqAfKLh4xv8E3TC+ckj+VQNLshJBRyLeuO0WFZDaILcpNPRmfOqQstjYbn6evmBCcJOWqoPEz4i4Pb2JIt1knbVXtvKCpvCmxzy0m6Z3tJvmnde3z7Hw3yqHSl+a/mbGAVK+bYvmi+R4wsJMmBrrGrORFroAU2+cyII9D24F9siwT1UY9Yp7JiHTItD+FsRWbcTZxosg4Cjnv8XfO06i33+S9OUqXKx7PIWMaAKio0r81FQ5ef9BnLt2mgRSQsqDEJ9vZUtzsqS4isIpLScGEJtxHmlEP2HM5zesFRpcfXd/cSt5EowoKkKf2xJTWFONNgujElZmti7Gvw9ZprXgSf1J8ZADpn/XooVS2t5Is8bajTdJTq9rJdX8ViIiPIzqzGJw0MB7nSf34JQIdYf/af2uhwl3dwPUFsdUPCGUI9evbFc2vHaBqIEApkZaevaCRMs390UYXxGyzEC6E8kV8MhSNhwYK/M3HS4TVUi+IiK4WmQB1ThZtaCSCsoGuFSWPXv5yhwnJ5JDhMkhb0EoZTUXmYDMGOb4MDGBATNydNMfYtSYgp6rEvbVO29sBgOZgDQOdkHYs3aSmyQwnPxpDxMqvCF50AzcIgOFqxnii4mvkKcq+fdV+f3MibEJNK/qqpRBGKTMvH3NjMoQQDJAQvU9uVNok6co/VHVQWt9Wcu0eH1s6qS002RK1tSzwtWuAAv40v2CxhGi3P8V1khf0+ZaaPcPj0rtPcgkTRd3b2XCScvGyBs2KQGVb2vikfwk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 11:51:49 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> I'm not sure if the git repos are lagging vs. quilt, but as reported this
> patch breaks the VMA tests, and the tests are _still_ broken.
> 
> Yet it's still in mm-new, mm-unstable, and even mm-hotfixes-unstable.
> 
> This is interfering with my work, can we please drop this.
> 
> Also the v3 is currently being debated, so surely should have been dropped
> until we have this resolved?

Well.  I don't drop fixes unless it's decided to be a non-issue or
unless a better fix is available.

I've done this for ever - I've held onto "wrong" fixes for *years*. 
View this as a weird issue-tracking system for a project which has no
issue-tracking system.  It's to prevent issues from falling through
cracks and getting lost.

It's unfortunate that this one causes disruption so I guess I'll loudly
comment it out and track the issue that way.

