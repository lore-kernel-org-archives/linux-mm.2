Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCB4CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391818E0008; Tue, 16 Sep 2025 08:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342128E0001; Tue, 16 Sep 2025 08:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230918E0008; Tue, 16 Sep 2025 08:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0ABD68E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:45:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BD731A0159
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:45:31 +0000 (UTC)
X-FDA: 83895084462.27.5C06B1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 068961C0011
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:45:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ptuA/Ovl";
	spf=pass (imf18.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758026730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HymIZo67sGlVYXnFH95OqFEjuVubkP0PwFCYhDrJOj4=;
	b=p4mrRZrinjpg3JH7Ait/Wsj+OVXmdpTO/HbKSgZP3HzkafthYCef76+DWZqcyY9LNd5WM9
	6fX1qcvWDwmdQMAKEm70BRyS33+fOTOaLpuojKfpmCI14E5NMoF/FECaxIDtazxeEKNRhl
	X/WYPWAcUVyy7ca2+Ymekx+UbALjrOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758026730; a=rsa-sha256;
	cv=none;
	b=TGGVB8P3ODs/lSHH7xx8D8uUt66F37WLxWzigbtT7iv+Vli9VdoiIi587MSN7d4L5zuNRN
	77Y/uHlg+pikmvzKeM9xXO7Uh3q6ypMzaazoldUtFO7GyFO4zXqi5tlh9u/2gVQ6nX1VpS
	8BmGXwZomoUDDyxVyXLVDHKXfp7EDOk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ptuA/Ovl";
	spf=pass (imf18.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D67F6013B;
	Tue, 16 Sep 2025 12:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FB2C4CEF0;
	Tue, 16 Sep 2025 12:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758026729;
	bh=Q8b3LidWHXwy7z60vkFZIq9N/I8zXE5IsO+IFYXOuW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ptuA/OvltuPdVFVrhaioHbpDtjjM/9DLVoKZRVx29LpT6Lc27PzSLHnMoWj+LabK/
	 eSB+1RL4IAAJL4T1VXQJ5+iYTsn7JXgyGlOH4hzbM11KXJFo6qB4aU5mlTE/iTrs37
	 aPkgsNTYjGHXOq3fe79+sF/CACO/9Myq4aFvNdzvvbjDzHUL52XDc12HUyqe478iBS
	 fXIPutO5ul1uTbTGhX5oNMA15xV/XnW2crYH7vx7LIJdw293p9Y/CN0DlDz2CUlZBd
	 g4BCf7eHVj2CB4TlEPmfSE7rQ80+8IFDAiIdOnz3FV3vdCPukB3fyUoG7YXfQAV+Bb
	 hJlsJninGzF8A==
Date: Tue, 16 Sep 2025 08:45:27 -0400
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donet Tom <donettom@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
	stable@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
Message-ID: <aMlb5x0eWA4rpVKe@laps>
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
 <20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
 <aMjohar0r-nffx9V@laps>
 <20250915214117.5117d339669e091b1d3fa96d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250915214117.5117d339669e091b1d3fa96d@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 068961C0011
X-Stat-Signature: bggdqmp9axngjsx6tdyjpciipku7f8rx
X-Rspam-User: 
X-HE-Tag: 1758026729-609660
X-HE-Meta: U2FsdGVkX1/IV9S5pjAQkuB3br55mINqWO0Sfn8941IQNNHj2Rs0VyALX/5K5Uo06PzzuSPMJnpfgm9ycrAWWYyVuc9lbGAOhhdX2RZwSBMx3s5dlfMGCgfpSTASUGGOLqd5iaeFFNhRlU4AqfXDm6LlGbUvV1VMbyYjPjjqFY7SQ9OJLXbnN9P3/yYRUPmErKaOGb0jJv1X7BV5xMXGNoN+/5idrxnaa0y5Wvoc/n057GOASQg9sICd1HSizaAHMz+QSeY+WxAIPcLzhoWpVQI3nckTNJnQuml+tEc6hSGbGL1CqPybouGLAXG+wVh+eda3i+o2g/xTj5ROrTgmdffn3Qkc0EsQCtmKGc6wn8C5VpTqj9V2Bc0ZYLClSRshPw8KlpVdLEZms9CFAqezEYRUZtYeqBB7IbXTzbYMgM6EpGLpuUAHJeHcJNLnfSCWyZi0kXJ97JncMieowJxOn7lur95qg7ty2wIfPV24b3nGEs8vOWLdIYCqHWH5RRAnDvSScYC7VSUhoZu8EyjZJIHkI2/xKaINX9nAZDeZKQB3Mgf9OQYKxr5vV+MyOHWNPnbkEh57ewIENq7aCzoP2keolHNmYCpXQnyqutCDEcbpJpW/uqpfOB2nNeN69iv7l77QplvfTvZfX6nk8uOScMHhRaqpZRtapzTXfrUwS88lChupE7LVoDuzX15Q7yi+l96QM9kUEpWo8PmxBNKTqXCQYg+YqgRcp4so+X6M151Sn1QOyNfiioqocIqyUKtOA2fjjE9G5lVPU5EECzS7SFjdXXSCkDAeJSKcFlTGpov6BUJAkEQudJS2jGlY7PdCLi+9TLARnjlGXQltqeI5D1NXK3HBKuOy3bpqWasUsAqgctEKAx8AcEnQjP8vE+1XO0WXwBO6VINtBhApk0Pk0SzpCzHT+s/wltRYAxvGzL8SghrRIraW6+7T9AV8JD5/IErZzNoo3u6WUtpZa89
 8QctMzO8
 0n/UXYYY4itTkQF8QV0qh9UZmuZBkVpq/YDFcvtqjXIRYlrME62ZWRm8+rcyBFTrDrXHkrA++rFF9A+3nhLmMCAyEaKRbpL125TnA+rW3LWY8UYM2ZIi9mUogoIK8fCNjGKG1li/G4JLqpKSEk+mtV/XQzyam4PzLBcNuwb2uO7wGEKhGbn/383jY0OUA3J3Toiv7rT3NEA77hCtY+J4xv9GuTOsBZQEPMHA4PS8xNJeWhjw214KrCuez6dY7v9xM+Dv2AShNymzpkWWqtJmtfWuQT/1AKO7cpvjEXYPs5g87DzS36MwEOUOKTRkqcQFHCS06YldaZAgxLBNGYlUyHRd6/Hkj6DzAaODb37nXfS0kNmF4QM/y/gIdOI3yHVLVe8zTKKsSXnhpi7Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:41:17PM -0700, Andrew Morton wrote:
>On Tue, 16 Sep 2025 00:33:09 -0400 Sasha Levin <sashal@kernel.org> wrote:
>> On Mon, Sep 15, 2025 at 04:42:48PM -0700, Andrew Morton wrote:
>> >I think the most important use for Fixes: is to tell the -stable
>> >maintainers which kernel version(s) we believe should receive the
>> >patch.  So listing multiple Fixes: targets just causes confusion.
>>
>> Right - there's no way of communicating if all the commits listed in multiple
>> Fixes tags should exist in the tree, or any one of them, for the new fix to be
>> applicable.
>
>So what should we do in this situation?

For us, ideally point to the oldest commit fixed by the new commit with a
Fixes: tag, and then a note along with the stable tag if this is a more complex
scenario that we need to consider.

-- 
Thanks,
Sasha

