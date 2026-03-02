Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 816DFEB3637
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE2C6B014F; Mon,  2 Mar 2026 16:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D716B6B0162; Mon,  2 Mar 2026 16:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E486B0164; Mon,  2 Mar 2026 16:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAD2E6B014F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:46:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67FAC1C31E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:46:03 +0000 (UTC)
X-FDA: 84502456206.19.4115E98
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8577D40014
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:46:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fABwRMva;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772487961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWrrIMuFzFwLJQr7vT24Bua4IinIlHw+xQt+HPa/8Pg=;
	b=XBJjr2n2m3BhGylUhMTpoHXwB2DS2Ez8HPsBYN9O/eHxO+1xc++iGffcdD7pp/6A8bCL6Z
	+Zlvzjr1+dFbIuVpMCAgSKNjoCQwW0z6z836I+obq6vhezE1WqWb/tpfhp2BczPQhpMBHu
	DkmpMshOLVT5OAPFW1yKgfF83I4Ou0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772487961; a=rsa-sha256;
	cv=none;
	b=N7IKNE3+n36UgAHDfatVoYuLTQG6WobNMziZa4kYGvOsxazxgGjQjGbolCNWC16dHVEcL2
	vSWbBamV3hUy9/b3EhHm5DKnAi0JMLoIDkPB5bFQjBpaZR4qvqqy2abSTqhRXA2jzndwls
	eFe2ImEbRjLHN9nSE7ibzNt+2XnRkPA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fABwRMva;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 2 Mar 2026 13:45:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772487959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eWrrIMuFzFwLJQr7vT24Bua4IinIlHw+xQt+HPa/8Pg=;
	b=fABwRMvajmtIARyCH1jW/c9bR3kNPE3aPVy/raO7xPGcGSGwHN/6h39tTeSmVlfJaradFH
	yJxESNa/1T6vGn34+9Uu3SarzkEMqOkc5m7apPDHsOA5VuF5+Xg1axf8wozZaaHAuMt0To
	S13crEIR2Rk0dLAdTPfaMxJhSJz6a9s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: memcontrol: split out __obj_cgroup_charge()
Message-ID: <aaYE9EaBvz3monjr@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-4-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-4-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8577D40014
X-Stat-Signature: errb6mhunq49xdyboomxux6y1fokwyg8
X-HE-Tag: 1772487961-200867
X-HE-Meta: U2FsdGVkX1+SXSo93r3uNUHOt89A9EOUE+ti8GZ7hH/PoYoh2a3I1cq/SX5XcBbvrk09O9XNtKoS7unc0tyvnrl+CbRHT+hpWlLABB8xaD297raVjOAiSqhzCfdyWHO+dGlkQEEmJ3XVekfILzDXlkvtIdtt3cUzTuj0s4MZ4kcXKgMSgCOSMaZ7HW5YYRGbKSNPn0VXWUgGsGW59TApp7nnHmdC/bDgPBCvEqKgVVxNIwKZ72VR/UaGY9Iz5mBMtkIP0yBtmKdq80W+TCHnVqnrNBpCbaN7XAlqRTO4amlPlyUTYuGFjScDwt5ruh6Wh9/7pGaLpooi5KeIlYQ4i1Z+92rpefL4KgFJ0nm7X7fhFxLn91jDYsoWR92BHiBPtIRw4r8r2/z9ibu6sc0crbFsL/1tLjgAuAXyWGV6aXrjYBnkwY7GAvoJIS+H1/UjA3CEehoepKBnUhRN/6uGJLqeyoQDxNuk/I/PMrQxYX1Ef1s5GEzcwfxHjAzZQNbtNUDBYbJcYw50Cycde0kkBUHjo7M5bDLo8TW+Zk6PmGQ0M14TwQW3dCtXhlYfWrh01PLU7iHt8tJN8Ix+qsvdjfejud6qG+SK7Jlkghlz0dMQGqqJ3+FuLPdTblkfgwHgUPih/cHmwYo9+28sgijpmSh51OuNvgDYR2N08onexB2XgvgXkJO9Fw2K6bF0VoKesHrKkviz44n/4OOXir8Bn7tXoQAYM7twJcUvZ+cD73HQNrpn8IofRYjyv5CymZ3ot1PPwrN5Voj8w6GWzR2s4XlRuiXfnCR5N8a3qp9t8cIF39kctX+KbghrlnhZoF4VNe8KV1uaAmPwOwLuLBmU/aQnQt8x5aSvBCmLRKolREPdPlnejqkA8xfh2h/f3zVGTd1xmc1WHgEnRhnfim353yg48QAvYJg+0qokmKLj0EmdvYc60XgwU77tqg6Gf/VQbBI8yM6HvYvS6rcfoyr
 zvGFa3+p
 NrS9uvnXkN+fEaVwoo+ygr7g+XDPbZ8Qa947INXFj3Y01nGLRVtU14ePR/URLoO+WM9oYyCTKAroi7MBWX9OEptdU+/quGwcmtOL4EAg0OX7Q5SI9zEkBrNP7TQwBX3+0BaYp9GDrrfiA5gzaOyBaCy+0YZDiu20bZyeYiflC8VcZ1ZS/+SbcUvQXB6Leo+brh28ta0pZLxNbI60Byk21c8J0vjXtwE+krVh1P5rSigRTPK5czIVKEYcmulRSk7WohVOd2IkiG7qgeyFyNT8twmzgKh/fCr8yajchMCwRb/pczvKWa36h8xeKwRin8TrEbO5ajsTBZIi3V+E5c6dxb9qD0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:16PM -0500, Johannes Weiner wrote:
> Move the page charge and remainder calculation into its own
> function. It will make the slab stat refactor easier to follow.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

