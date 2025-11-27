Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB85CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC18D6B0011; Thu, 27 Nov 2025 05:39:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99166B0029; Thu, 27 Nov 2025 05:39:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5F56B002A; Thu, 27 Nov 2025 05:39:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9818F6B0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:39:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 469C5C0626
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:39:11 +0000 (UTC)
X-FDA: 84156039702.10.F1A5BED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6CBC18000F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:39:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tdrDspf9;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764239949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WShzrpUDnaoR55hhCEpYkKVhzaXHunjgWOw5262LPZw=;
	b=eN0R+7fm0dv7OqtScLjrnlKARbw8yyKwcXNj2GaJAEdyXPBUfaI5MnovrCEF/x4lzd6aKF
	qIiqRFpAukOyd/OIZrmS5UO9QptXucVcWv5vrYtoYO97NYEXH9Zi+l7KN9Yxd3pZJQ55dF
	VnIapR+WYTkhM9fInThSX+lNDAsyzJo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tdrDspf9;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764239949; a=rsa-sha256;
	cv=none;
	b=hqi4u8LpbnqNi+45JPXRvurnGeic7MWrTk59h828knQN/HEwipLQcXrydxknRkLc/zNUvM
	5yRf+LonEoS6UP8z5u3rkNkx8ereqqQ4SY+Cx4hHzyHS7RuZt2LTY5g01JD2GwZVyKntxh
	eYydXdX6wkiLcTASK38QtHWbLaDH0k4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15852600B0;
	Thu, 27 Nov 2025 10:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645DAC4CEF8;
	Thu, 27 Nov 2025 10:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764239948;
	bh=9o1jZ8Oj1DOfr27ZVVqlDJBNXIj4fytpgJFoLZErDXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tdrDspf9sqnTmBIOYvod/rDMAzZHXGCJUoTEMVvCLFgKmKUvLHn5KthSzXHbY6DSN
	 28Z3u+Vwg+5o4ehdfQ103R8cHF9GtKLFVGP3pS75Ki8zXd01n0cFocmT5blduWNEqw
	 0bR+FC4GR0WFX1oXAPfY8krmw/qKdRuLUL3CUfAD1z6hW1ZUpG775MHQOHRUKm41fR
	 7CJ0N5WxfPiUUWCb64he8prtusjo1bMXC/oZpGVl8c8xzIiZLmEsQCGXI09cjE3Aws
	 4VoXilNuLmNFvFDSP9LZXia/IMiIXD+vMwsGwgYo0kXizRa9fcc+HbTNbuM1MHskpK
	 xZ52bPX4oQM9Q==
Date: Thu, 27 Nov 2025 12:39:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 5/5] KVM: selftests: test userfaultfd minor for
 guest_memfd
Message-ID: <aSgqRAF6Ih8u6fdP@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-6-rppt@kernel.org>
 <18b4cddb-3e04-4272-9f04-6857cea70ff5@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18b4cddb-3e04-4272-9f04-6857cea70ff5@amazon.com>
X-Stat-Signature: 6dhb4mbyesafur5fy4rx9y1jujihj9iu
X-Rspam-User: 
X-Rspamd-Queue-Id: A6CBC18000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1764239949-523946
X-HE-Meta: U2FsdGVkX1/v90kbKu/cMduL9oqF+UBbZBR1CRAGBegOk+K843jGuXl/aNg0rH7DXJE+6EqzUNVnVNsr83snp+NJwds6fLuIpl2lVM/7ffXEF67lbOtSYgYn6biJdYmn/K48NKQZtNHvErOyZYROS9Kl2Zzg1V0VjMN1E91WrkdrFOqimKZ7nxYwdphqu2FcnfFuV5Z7GxCFBihQujp7br2STcSr1S7X9ATd8zOjLbulfPYRwdn9bl+NKqQQPwwHZwrVrdukyYnNNJtjG7drAn1QfTWOoxfP3ldh77G+vHJ4dm2H/JML1B7aV7iPd1rTiZxB+qD8T45Y1OQE9MyVdhKwXPimcI9W25sLxYx5SuEkhT071S/UKUzAL+xis5Q0QhITi3a6sJdlvH41G5dXQdrDZ56dIFpUcPv56DBz2CIUAa4dXboZKLQI6W194xZAPBVCqYmOJw6Kb3hGZWrOm9PlrqDS0CRW7XiBfgRI0Pc/ajoLjHvU03EF3l8v1csqNaWHgwJikIj0iBN+8RcI5jYWF79xXDto2Xl/7/d+QLu6RByLBEA2u1hGDqWkCfyN6SNhCHNv0mGXPmw5bEZkMBV8eNre6VsOeFp+ZjXj2MGzkWssF3dxMcbUNdEijpl9zt9amIh20bnDz5pklx8R+PZzXaiP2Vj6ntn0B214juz4c9NfBk54Jk5uJ9wUuM1KxjBIJDOr23SGY/F4u6FG7O+SKzTOnE0JKRU4RxqUjGrnjHpyL0UY0IyqrQ27omZb9mIgZCnCs31zCr5YSQBDiZrn9T1xQklgUISWf1HGxofg+yBaJwyGw1H1aj1IsbfwpH5qJZIHzCWhpDoLIGqChYXjyOM4UVmsFs/DuUuyquWZUJyPB25iMIgSsrC2nz2Ft4L7plT7vyC2YeBqqFaPwIFTXLkDmPJ/XibRpQsY8CNgYdTsI4yeBNI4yNQDYXsGkZY1jVZDPZtfw7/yMbG
 oXdAD5wi
 o4XSGMACIxxiLwPZIc8Neo0l7LmSaNv6HX3d7N420LVGVls/ozuAzgSAE8lkDaLcg89KvQfxQyvjqpz/gzPWvovr0k7ztF5HiB5UQp3bBuezew2wdbMpREoR66sYOr4MmD5bAnGabF84SPTezdWTxVcmRbTq+ASAhjm7uTnjch475/c7jIfdEz5nOR0qKLu0QECMMG6w73jA0QeUBAPm1yudwztiAsNiTiEi8qYQiNsxurpv4PvbYQ6OoP7IqyI+Q1GTP06g5y26HOWjCzN1JEueihHeM3rM8Kc8rQ2bJ0FhKAMoa8t36bo/TbRjX9NnjCeL5/FM4WsWL50w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 04:49:46PM +0000, Nikita Kalyazin wrote:
> On 25/11/2025 18:38, Mike Rapoport wrote:
> > From: Nikita Kalyazin <kalyazin@amazon.com>
> > 
> > +static void test_uffd_minor(int fd, size_t total_size)
> > +{
> > +       struct uffdio_api uffdio_api = {
> > +               .api = UFFD_API,
> > +               .features = UFFD_FEATURE_MINOR_GENERIC,
> 
> Should it be UFFD_FEATURE_MINOR_SHMEM instead? UFFD_FEATURE_MINOR_GENERIC
> was removed in the v1.

I'll drop .features completely, the checks in UFFDIO_REGISTER are
sufficient.
 

-- 
Sincerely yours,
Mike.

