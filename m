Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C461EFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1255F6B0093; Tue, 28 Apr 2026 10:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7256B0095; Tue, 28 Apr 2026 10:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07736B0096; Tue, 28 Apr 2026 10:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E01EB6B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:21:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E268A0199
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:21:45 +0000 (UTC)
X-FDA: 84708178170.29.722911F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9ACF316000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:21:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9H9FwcE;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777386103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ET8/NknTsJHtlMuALnNbw/uEqBaIhaD5BUUYg26v3ks=;
	b=vfrOXfltiDWZzqrCmQDwl1BPFEln3Grls3+6ODRBGO7IVoXg0MpCmKhwye0e54DnJAzxbW
	iiN9lkFDr9+R+Jf5EKdhwYo9kajUXvEwLc6gLPm+G8vJMCT5ZXwfIuy0/kOFzI6IU4xwc5
	LQ+o1iMTMkAWD8tkk5idXngTarTUbOA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9H9FwcE;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777386103; a=rsa-sha256;
	cv=none;
	b=fPKYU8QKQNUx86HPEOz+g+cKjxBQynh0dUUISmoVQCsAurqZcWdA6tUoss/d7/oalJbRRD
	c/Guu+snRT9L4N1DYtjCJqV5Ic4s3Vq7c9xqBqh0RonD5w5luYQmGLuPgaW0m2EZ6L1yGo
	NQXaPnzexPUelEwTAN30bwpws7EGxxI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BC7542AB1;
	Tue, 28 Apr 2026 14:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B87C2BCB5;
	Tue, 28 Apr 2026 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777386102;
	bh=zYVr8VjRbDUPgxlcymb8HZk4CGyioa94jSwOemrqBLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9H9FwcEdAxOnQCSMarBmTDc8SNRisq4zOckB6tC4rJsL32rMdeoCFb/DZnNAKLs3
	 GBOCYFnN9wmzc98CPsH2+6m8W8qWk9PpdOwSTk3D6s1vhKAOo/R6xh2XvaqNZinC4h
	 CKJG+XOcIifLl20IEDbA31eNEkA3Tboj8sr8+1BwClljDiBm/+4/tP16ClJvQJ2rIM
	 2IJYOrAJqVP8VGP4tJl1f70OJs/m3dAYSb/xtuzDSr1prt9xtcVOdh3Y7TU/NEmZpc
	 66geo97S8vgKEhMo3mRA1cQyZnt3lBlM0+s4D7VqfRYmQ5npGc87zORxeEF/oA5s+H
	 KpmKolqt3iZ/w==
From: SeongJae Park <sj@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cheng-Han Wu <hank20010209@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] Docs/admin-guide/mm/damon: fix 'parametrs' typo
Date: Tue, 28 Apr 2026 07:21:31 -0700
Message-ID: <20260428142132.125055-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <4b36424f-218d-46eb-88d2-a25f146fb792@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9ACF316000C
X-Stat-Signature: gm8c7mdkk3q1mm7b3wuhe8kzx1gmwmyf
X-HE-Tag: 1777386103-778736
X-HE-Meta: U2FsdGVkX18n0IKqJaqEVZp0UNu7Wpl+N2OvFU5dS+dE6y5HhmT3VKRFkVkG0sNOvtoGCwmNaPEhVwlIOBi2g1KRL680Iq5nmkMlVSNDFgg32i1aIweoSkEixdON/oVjNIViUPCXMEDZzRru8wDi0l2IWtz6GOcbnzzHdMOtkOks/bQOntfFI7t/8uX6uwK6qrQmRcLiDH5uFZ4tSqaBkK8LssWNd29rvCHqMEPpqTBtXOsqF40Lk2+PXsFbiYRTb3bG/sjkozO0tnyJ/TYQPmSS+e0CFLnTHJDvt0+SNzsriWPOu/9GI5BQcYE4c9b71CROLTpjcV845ZE5r166UOnlkUGYLr7wfW5iSzM+QRmiI9BJH8UDK/8ppKnML30aPnsE+jWXV7a7Ude5rhae5YsGPYWQ++WYUFQL8EQIa09LtI+pxgRVrbcjiB7u2UaLpwYdvPjekiioAiORN+LG6iOTzn1lABIerIpGJwHUXWa5BPbhOo3XoM786ekXehqXAeumO/Z3Xs0oSMQih8cMl+j5Kp/Eze3PCOO0yvuUgIfS+z+88T2jxFOVKPhUJJVOGGL/wnRGiIlo6LWOeqGHDuJdtIkNmPBdkuSm6oGNQ6HKYI32cNMqFCuEHVhhrTnMD78fvnHPpm9fZ/gs1+LnEnM4PxbmBZ7/aVzTeXP2bVDOn0L7iFV471UqxbbZiMYaFj0hY1sCbZut0Rv1tW401FaHe8RNgemMlkfP6Hgdi2HFxSLpFY+zn9hCUNM5a38etWtH3MhValncFkI3KE7ot1crgX7wYlCObo7y5TBAlSWis4gVRr9WvFxjYohVXlMOoKGDgmRGRm2iPeO2EI1PV2ou7DiFSdXYnhnxbOpRGUXQOEigc+nEQmnz3PmtYVxMz3nLMW62MJyu4wjZ99PfhEtTFDgQq1k9Fcl+mjknSxHANiOfXPGp6GM28Y00mcvsUjRxkF+dwCVndgV8qM8
 3fp3DLFH
 sEALrcdb3v1dLUhsTGgXOvGijVnNKmdWe9FZAJpDPA362NlpR+ul/eNg8PvlaKEiJe+9kB2qs2hfsQGh/nf9JXGv/J4lOCz2JB84U6QcwCwLtO64Ig5rHqn/KblDMMvdGwI9l6NoB+I+5hEqkKvzBR4FFsU+6KGmScdb2ilZ0QPSMo7JnsdiMQIdlY1XtwFvyqDybfUC827/RmBk+eMjYiTjd5XoUKR/RfEhsQ1C31uKa3w8lAYmqqHncraQntmaVaWUv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 09:38:02 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 4/28/26 01:39, SeongJae Park wrote:
> > On Sun, 26 Apr 2026 16:16:15 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> >> From: Cheng-Han Wu <hank20010209@gmail.com>
> >> 
> >> Fix the misspelling of "parametrs" as "parameters" in
> >> reclaim.rst and lru_sort.rst.
> >> 
> >> Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
> > 
> > Oops, I forgot adding my Reviewed-by: tag.
> > 
> > Reviewed-by: SeongJae Park <sj@kernel.org>
> > 
> > Andrew, could you please add the above my Reviewed-by: tag?
> 
> Since you were sending that patch along in you series, there was (as it
> must) already your S-o-b tag and that's stronger responsibility than a
> Reviewed-by, so it's redundant to add it :)

You are right.  But, not having R-b tags that I provided on the review stage of
patches gone makes me feel odd and bit confusing.  Also I made a weird tool for
checking DAMON patch review status that doesn't understand this situation
well...  Maybe I should fix my brain and tool, but if it doesn't bother Andrew,
I'd still hope to have the R-b tags on the patches.


Thanks,
SJ

[...]

