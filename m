Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04880606A333
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kIAXvQCU
Received: by kanga.kvack.org (Postfix)
	id 0D5CE6B0A44; Wed, 25 Nov 2026 10:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACE36B0A45; Wed, 25 Nov 2026 10:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05996B0A46; Wed, 25 Nov 2026 10:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D17316B0A44
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:06:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66C75160EA1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:06:28 +0000 (UTC)
X-FDA: 85473967656.15.816387A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D313C0010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:06:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kIAXvQCU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795619186;
	b=oDu+oU4RnpIb9o/yllnOpjiuKYTyAF6h9Bfcwe039z+G0dbqrlZ+XKRXiTrcrSEUjrr4he
	HMQLh31gRDO2fYNrQKZJ8b3qda3qQTFjySKVFEb7zlcpXxt7UPj2zlVtgHslTGbdmjpezh
	PgjSuYy6iy+nOENCJo2sr/bpW+H/LpI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795619186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1Dg38/TSL1Kz/srxgh6JrLfoKzHJgYzjciASNJ0TVU=;
	b=MvIdEwWuoDLmxqswC2sbjJVz6m79SYsd4rZHLqIxe+tYj/jeDw/na+w0yB5Ko3H6eP2C/J
	972uirkXevtFrcPBNX4OclEHQDbLQB76WcXW7qVnejqMLpjVDZvJ/6TOT3x7OBlLMuwEhq
	W2Tt+Y5N9ew2JeAap9A0x9rMijoD2rw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kIAXvQCU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9ED122F;
	Wed, 25 Nov 2026 07:06:19 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 814903F86F;
	Wed, 25 Nov 2026 07:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619182; bh=wUo/6Std2BwKt/SvSAaU1+xDTODBfj83yfrYwoa5q8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kIAXvQCUE7siDlFw4JkX+Gt3B2vGsHfg0yI6O7uuMaK+jEevJJGPzbCrngt4QeKcN
	 d4h6QJkHo66G7qgOYORWqn2W3nOKRGcfsVmyGBdlAMg8S+3kGWTvvRtcg3rDtvC7GN
	 oD/ecGYKBS72HKPl48elYjYielJa/agf3FBjh35E=
Date: Wed, 25 Nov 2026 15:06:18 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Aveline Noir <jm5905938@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>,
	linux-mm@kvack.org, Ralph Campbell <rcampbell@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] lib/test_hmm: invalidate all mirrors on device-private
 migration
Message-ID: <awb5agUP80qz8iss@raptor>
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
 <awbtZjtII9h1oJ5R@raptor>
 <CANOyQmGPHrHAzVW70Q8T3AYtzFi3C7jCQdd-QW0rQCPEf=ycyw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANOyQmGPHrHAzVW70Q8T3AYtzFi3C7jCQdd-QW0rQCPEf=ycyw@mail.gmail.com>
X-Rspamd-Queue-Id: 8D313C0010
X-Stat-Signature: q6bt8awoidz9d3q5afnq5g65ytryckh7
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795619183-778565
X-HE-Meta: U2FsdGVkX18dhFAFVh6g8BjitJGIYJkE2lmzG70RyxUMOqaVf02KQTDHQv13BdEDvuI8pWlqKdZ+UbQ7pwFt7wYoqPUEh/eFqfywFcC2lZyFfEQwoJCQfAcljRHEB5chYnQj8jBQVP2MNNpdOC43L1QPqNsiMIZAOX4/YgVsmxwD4tPJ9czEEyCNXp86A/jvjyH5lfvRXYYvYOD6BXRrx/DDF6KkzqAqxS9ht6HTLqBHw6dTptfmRCNbjpzj735ctDq9M5Zn4VL7ZQnNKDcxqyrI3z6GGv2rSaMm4n/VW9klxjWrrsA4SrMWMkG4TWmxsNNE6KbL4AVRaWeaD+uKG5ahxN+qOiEGRMwvSoIe77YEBMpKWep1om8Uihk47wudxmAD8w3oZhPVz9PWI5EpkHfZSDqUJx5U7QpnWwSDaxQQDC5YQ8HK8VOGaDy7BMjh5ZzEWoP00aoITQE7slEwRSSUl8v5MMHkUASdEUcIz5ZZEq/vDeYF2BOqDuNv/mMvigpHk1GP+zWp4fWEV0Cdc9w2NMP4s7gnCvbttNsfUcJr5dkV+hAd/R1Otvs0aNCFNR0+EFuxNMkoBoPN0fgBg0dCp48iqOXLX5eFbBp2TKF4lSfr+yCmSxLdRlvVS9CwIUZzEwHw8PgoEZ1oVml710+O4dw4A2CjLUNif3fd1ZyGDXg4wES9Uqf1I9kp6y5uDddtfbvF2g1+I0QztxNzUy5XcfLwMiS6mpGmJ0MK5C7JWHAufFH14yF79UsCkAh/HDX8VoxyJzySOuexfB4JN8Ej0vePtuLAhc5f+FqOTtRTiFfYF7BEytCvxvi2/Y4R+ybkjplAHwof98G2o00DVOEvKzsQq4qVyTUt2ksUH5TkUYzwWXKHbFtqQyuuXb6Op+1Th8OwejQ3rsNM5G4SJzc5CPAno3rwB42HhucgNzkYcfLY58g62XNLc6a2twtYYpW22KpXfPlDbkQC/oQ
 5cNqrojj
 cB+Zd1u3ee+HVsfHdyk3G0adhOfQg61aMd2v13fzWj72tfXv+wV0UfgPZ44Nak851UNYcREqPVO9wYzVUcm4Z7oJJ1Zy+96MqipOzT91yLc89unRL/pQWKHVO9YG8ojSpVX/5QyKkekiotCn9hUrqq1DbDIxlyUPhgejhnNE/w64f0oThAFW6zbRuHvV9Bx13/hzOyNP1nBJgGNsKTAJZ8Bya5USxFft0/bGS32ofb0q33gn8FZ+YfDnxa3aJctidfdSbddQzYBOTOFbNYY858Qj2ZHSFSm9p9rVv1dK9BN5N8BPwN8UUHjopkkLejvQ6x6wi+9FEanIDpMToPjpR8Hpim+Yztq2In52IMCb9K1rNdjr+IStfMJRseZGZYISBN+EJyFGWxMkWNUlw0V1jkioq5WlzXhGEt0QapBpI1padsdZWwaGFPYFvsHQQt8pc7dnXuouQnwFj+Z7C/PXxJz6sIG3n1TsQtWQcU44XrMWorXfrBWXeUlM/LuIJ47inMKAO0hlxA0Rnt8Boz7j9b5wLwYkps2EOR2Ah3w3btbGuioHc6UpUhIb74WHsorB4g9fTMRFHuDIINFT9YhigW7WhhMKX0f/aKrp2P3I53pQjgxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Thu, Nov 26, 2026 at 01:25:41AM +1100, Aveline Noir wrote:
> Hi Alex
> 
> On Thu, Nov 26, 2026 at 1:15 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> 
> > Might be something on my side? I'll investigate further, but I'm not very
> > familiar with the code.
> 
> I reproduced the same 0 versus 523264 assertion on x86-64 when the separate
> mm/hmm: account for subpage offsets in device-private PMDs fix was absent.
> With that fix, the test passed. May you check whether it is in your test tree?

Indeed, I didn't have the patch in my tree, now the test passes!

Tested on a Radxa Orion O6 board (arm64 architecture):

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

