Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB698EF06E1
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 18:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1433A6B0092; Sun,  8 Feb 2026 13:07:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDBF6B0093; Sun,  8 Feb 2026 13:07:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A606B0096; Sun,  8 Feb 2026 13:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E54DD6B0092
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:07:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABF79D60F4
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 18:07:58 +0000 (UTC)
X-FDA: 84422073036.08.8547EE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2125440007
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 18:07:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PCkh6TOJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770574077; a=rsa-sha256;
	cv=none;
	b=XtUNyD6pB4ywg5eHA73q8oqSCmTbhqqg6b3LXy79wdpObRrmOKySaFrkGKi/lGKyWZ6XUH
	OZ3Oil5sGQG5lKKOUlwUqp9FzAvC2HcHDuIGywHxprbMwJbgU87PdimmrJhiSp2GUj9/C9
	JE9DjC5R1v6GVimP1MRglFdGjDqLg4k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PCkh6TOJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770574077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDzR9lpKjFEUV6LzjMz/jFbiERE11kuQT8Dk9zXCm+c=;
	b=YyCVANAEDYAHy8goyAO/mbdRwj2e8xl4A0Iep00YDXRDosSF38VWu/y47KxIiWb1943h9i
	415t59i56E/7buNnCBBC/Qp2xFPL45oDx6n+kfV1K9LjmFv7IUVMgnpAK6I5vIwK0a4RTq
	guQ9Z6VhjciGwggUOVKRawoKEjxBJxw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A8E0600BB;
	Sun,  8 Feb 2026 18:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5FBC4CEF7;
	Sun,  8 Feb 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770574076;
	bh=kQt8t7OYMDtNIa31uvKvR7rjvGtIHYQ481BGVMxx3o0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PCkh6TOJJvFbwBRVm1u4XSnuqOddU90qqDYh7bHdCfTliBoksC2mZUXnJ6aM/9csd
	 q5EN9teFq6YQCsfb28mfFOUt9tXnGZHFrKDbLeOsuGPhXeE8lkfUQzaTh7FDP0bAnO
	 RrROpFFspU3v6NrUtV6rz/FVijUm8MwCTBTHLTtdjGrZCtkOOfxEdo7HSGsWOLbZRM
	 1oNVh+YGmDLy13BHv5N9HTfyhrt6BVSGLK2yauQV8TQuaKKcIL2JuUSr+BDBtc6BGQ
	 18hko4wU0uu6JDzKvMrlFSsqmgadgl/VnYXl37i4IsnSjopbD+MWorp2oRQNaISbDu
	 lt5o7xLDLouTg==
Date: Sun, 8 Feb 2026 20:07:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v9 2/2] kho: Remove finalize state and clients
Message-ID: <aYjQ9FYujrFJVDel@kernel.org>
References: <20260206021428.3386442-1-jasonmiu@google.com>
 <20260206021428.3386442-3-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206021428.3386442-3-jasonmiu@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2125440007
X-Stat-Signature: az1ubsjc3q5yr9yf4uw8fse638b8bqbe
X-HE-Tag: 1770574076-729950
X-HE-Meta: U2FsdGVkX1++QXahA+/z5cvLohyhtyPbZ3kAqhgyQvEL5jntqd8Qk1INURzs5WlIeDidGVCkJ21a236s/j0TgkQyDYYoCaSXKcgjUKNau5jtCysi1AFvz/rSq69bgyJP87LhFqlD+kddvTIM9/Y0sJgrxWBdNlrBiO9voT7S1pSFRMKbbBjzPb/wEsjdqa7zcFGlZ0LGcQvYuzQNy+oN4tZYAUZgFTEnpSCZ/XZeu7amSRmp43P4jRlc0ePx7mI05WZoEvLL/6xFhP1Bx8ClfmRIT3py8E4aTbcgH+giSWpP0xhG89D5rHS/c2KBFYTO0jhB6cEROcokbyNQKY/RvDBeAY0ZOUO2QmEoxRkBUDYl4NxBZ6PhE7NBG8ac2TQEEGamzvf2rc6khz5FtEx/xzpIBwuerHzPXhsEmLY+SJeFcUfgGnEnzt/CocHCpYK+x/EIwCVceNq3dWGSHamFg63e/QNinuVwWAxlV6v4Z2QojIKxDoE2YeyDJ05su2aoVaoL8uCt4iKGctxk1cukKExtheorMSMdg+lMduYa/VX6hpYkSbMo4EyMEjqM23J7znQ+6kVLtEd5hXDYcb1YCS3fkqAGndzn00qX1URSiIicXp3kk3V7I3LhASBN40AER8fNIbWqHWcyJ/z1FhRpmHy5s0xNl3Mzswzy7CukMTzvtlvhk9UNNRS5hPwafhUIPNKop/myJ5qv5tkeJoiNsB0RKjxbfSG3k0qKm/C39cJSxiE9vBQ0IGlH0lK2NDxVU5bTPmC3ktsPdDzNjRp3vTA0QNjkQDku69hUyVn1dhENECoHwBQ5M/uqWL17b3A3bJToPmPdIWOnkRy/B8V8CQaJ9yQ2v5v8SZIw7Rx+9cguPRO7kWVet51m3tJHJHCngGrD4WfmDR5cqrTt7ARMRkP3Xf/ccGnyYlMYSQnfjd4pXCJi5R/eAv8vRvcs06Mzr71lbmbtrsASJkbkjsW
 CyA7uSBX
 0w4MVp0nxvmmx6nruF1Cp9zImigz6yEGCpoiVN9gSXbMq54ynip0bWBukOWv3mE3cN4t2Y0QMtv+atvFp1fcD6cDvcSV6E/o/GhhCiaD0d6kGdyQ88Ve2mvQEiVqI7fPEP7OvjYU3YOZobJDuVNPppLCHNMj25gODu4IlVdPUIKVQkER9ZDrVkZCZsqcOC+V1vLHvGUUwHloSinqWyxlF0E/xqg5d67cg/PDjK0jyQqa5oxXLB5VSdrhNLf256PMQcTYKN+N65AQXbYtXWjVqMliFKTPenLU667Vt1fA9M9e97+E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 06:14:28PM -0800, Jason Miu wrote:
> Eliminate the `kho_finalize()` function and its associated state from
> the KHO subsystem. The transition to a radix tree for memory tracking
> makes the explicit "finalize" state and its serialization step
> obsolete.
> 
> Remove the `kho_finalize()` and `kho_finalized()` APIs and their stub
> implementations. Update KHO client code and the debugfs interface to
> no longer call or depend on the `kho_finalize()` mechanism.
> 
> Complete the move towards a stateless KHO, simplifying the overall
> design by removing unnecessary state management.
> 
> Signed-off-by: Jason Miu <jasonmiu@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

