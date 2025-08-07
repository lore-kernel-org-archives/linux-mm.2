Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660EBC87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 05:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F1F8E0002; Thu,  7 Aug 2025 01:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7058E0001; Thu,  7 Aug 2025 01:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34868E0002; Thu,  7 Aug 2025 01:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1BF78E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:43:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66A6E1369DA
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:43:55 +0000 (UTC)
X-FDA: 83748870030.19.75264E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C6C1E80009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:43:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hb3nLQ3r;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754545433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h324Kx/T3q9Wb/zKqNsCFHN3yCBJiJ5d6XlCkNfYf4E=;
	b=oknVi6unX92Libk58xykEwa7v2zeFzOmT08UkzxmcmNWmKckFKs0skUBzbJeJboJ5laoGR
	dWdpLtFJAE6eew8uHh48WzTDCgSq/Ad3JNmBqecSKiNglvpbRupodguoRWyQnitcOUNaAa
	tZ2qOx4XSEl/BTliF1n/ZCxeQXqhhag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754545433; a=rsa-sha256;
	cv=none;
	b=hO6f6i6HkzzS9hxe3ftkRmpqn0JFTanbGU/I6pojJ++UH/Yy/lLvNSjL8An9GNHdWG5RI7
	Mn8BXMlc+RVkNH+bF5S8daXeapEBL9qjx/03vsIy8WCTdCEwk/bOdyB8ioOsGutf8yX6uj
	yV+8SrWs9dRBd0r4ORsdIGDL/+TbvBU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hb3nLQ3r;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8702941A41;
	Thu,  7 Aug 2025 05:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45990C4CEEB;
	Thu,  7 Aug 2025 05:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754545432;
	bh=Y8PwWxG6NhZ4hx+lZSLdvTGtrL3od2PF9xFFQ+W+ihI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hb3nLQ3rI+rQrDxsVy0fNAVqVVRPuh3IOBNbQwQffaCLHEyOmxW8ajOFndvk0C6k3
	 corApiL0Kw+Pe3p6j9f/AmG1AxjvmfuPzCOARahUqs5WCBN2LdleqYnugw5upmy6eB
	 2IARW757ZEPxsssBqjj5cTaFlnBdp0upaftcymIlBIeDS/ctjUQTJzPslcg6Mtcm6P
	 bA+NzrFlVseYBOkAdSbnBe9XhUyKq3S8ZqOhJFvXP8VLR3H7IdkxECGfD22lWVoMlW
	 fkp+jn4vf5sQxDI1dE7yH6DR2u18JLOe8anofFgEmSEwWeTf9MuvULRaV0BkOp1E9y
	 losb5z6b1LiTA==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [sj:mm-new 42/45] ERROR: modpost: __ex_table+0x1584 references non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
Date: Wed,  6 Aug 2025 22:43:49 -0700
Message-Id: <20250807054349.21561-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <81fedf44-83dd-4f2b-9a2b-2f3d7ba4f922@lucifer.local>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6C1E80009
X-Stat-Signature: cydmqrk3n16cpmghhj7pcbnxp4diutgz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754545433-302953
X-HE-Meta: U2FsdGVkX18lnWz68joHtzMtkDOJeQShQoMdcLwkF6ns+ZKc6KibS3ME0bF13+6LOyUFl4h8nDd7zf9//ZAvRL8qEo/Vk16IJqxXbUl+RXQSaLLaUlhqFE5rchNMgVelFYXGLTPHRJlhaE77aiS9n31K2d+/xjovrReth3ifYD8hs06yCoZGIq48wb/vTdl/nwnOYl0NnwgGKMDtytohwNfm7O9OWjMQpa5WfXUhCJ/gB3p8Pj5BEgHgiWw8cvGcrpvNSbVXn35tmMQys2hM5Y7VZ4/XIQGY28/3dOz32HK5YPJUGzkTy+k9JG5zXvxp3AsAMYTQvn3SRmZ/gg1I6wf8TpTUG/RZTLiPoIXq2WrQnW16Y0L1Q5miAXDqkUm+9LItPebqXTTYlpG3Sk1dyJ5BHIMjFiVAi+zaQ35ANXK3L+9PqkWsx42x8FHzhOirhtRgxLI4tH/qaCznwcxDhOHe9nVFUAnpX69fzIdmoVGmHgsNMG8+d3HpqW1ojtmKG8QI2vPkm/e9B3yHcbrPLVlIDA4jjWGeW9cAYMkMA99hB71zoGpywVJqCSTqwdfD6PqPYzEIi2va/7QPSqLgZ7w4EnWbKKwmPi2YQWv3HysmWDrERN9ZW7pNCsm1C7/lRFSlFGmLDI/tJtOXE+s/mljpwqe0svpFYsudhw57DhQ5E5ulFMwRsg1LjCsSn6RnROYcl6mXYD64lSHgdwXf+lKBCvPOrVA7X5ojFGSva1ZK8bl+np3+FsqK9uS/cmkLA2d16J60Rk2iSLJltdjiwoknQo231h1e4RnMsvcHRWX02Zh3rWHmTetPgZdvr/ctl4q425ui1mqpmq/n7m+8AGjYzDqkp2DaPl5M+7FYVT82ymbjue7c0yX3qvx7vo2UW0jlMRA7JFuomhBvEpDq2RUtIScvh+5LaFOV0poerAB6S1nzel6qh73J7kuy4X8wmrNL2Qk5aCMwkung4Ig
 FfrNcH0n
 gJIX3YGHRC9Cl2DQaPoTfZUbUvySO5xLXGxSsQnqIWdnSAQSjNkUOxi/FCEXNTnVQgqr+h7aewfJtRk3mGm11ArI1yLo8v+NCgAZ7htyHZry4gvwRb0wtaIpOefLUNqtSZnY1wc5s62DzISfTnapUKUbtTFFTZhHepyY8FI6e8x2uoWUQ1pFq0ZtAKLh9zfMARYVDew8dzFWWSZLhCS3gd7PpyU9QbN2G1FdEuWNHtBeuDlf2w5qlpsJH+lG/WSzmRbh5jvkVoY7/6aTb/AoepzPUJv76hJt9kibAjVgXkdW1Dsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 Aug 2025 06:31:25 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> +cc SJ, as his tree :)

Thank you, Lorenzo!

> 
> On Thu, Aug 07, 2025 at 12:03:03PM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
> 
> Not sure why SJ isn't cc'd when it's his tree?
> 
> Not sure how easy it would be for the scripts to figure this out.

As people might already realized, it is Andrew's mm-new branch.  I started
pushing Andrew's mm-{new,unstable,stable} branches to my tree for backup
purpose, since DAMON development branch (damon/next) is using mm-new as its
baseline.  Seems it caused confusion to kernel test robot and other people.
Sorry about that.

kernel test robot, is there a way to mark mm-{new,unstable,stable} branches on
my tree be ignored from your tests?  If there is no good way, I can remove the
branches from my tree.


Thanks,
SJ

[...]

