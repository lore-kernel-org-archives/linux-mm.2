Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0702ACA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 22:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B548E0086; Mon, 25 Aug 2025 18:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3198E0038; Mon, 25 Aug 2025 18:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246B08E0086; Mon, 25 Aug 2025 18:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 144848E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:38:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B19D1DACE4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 22:38:50 +0000 (UTC)
X-FDA: 83816746020.08.8BE6A94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A250F4000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 22:38:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CuhMQyUp;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756161528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkzSOUTjIpps1my0G2J5o+rGS1AQAwwKJ24f5REU0Nk=;
	b=AH2ejjF/sDmhdLUzJF3FWznSdtMs1Yswe+C+x/PE3q8FIXa+4FX7CwRsS5hzVBClPVuZof
	R2uAgYnIWUeuH3+9PxJqstPe23/ApMYjL7WU+YxcTYgn11lUaOzGoYrGE+VNZbZsx8LZCL
	d4cVyUmMskB0ePSEIrdAzFNdWDizMWs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756161528; a=rsa-sha256;
	cv=none;
	b=Io37Lb2wRFg0CpQlkDYnAufAj53MT/pYeAxN8vGFDioFwVUHkhz5bJwyuwFuzWBxtUb7KJ
	kVoEuDQnQe/SE24HI5UuU/R4O5kcV6oq8FWVvkBq9zoSayhUlsoqo6GZicdwBAC/BsUL5X
	E2PrFEaUgZhgEJ9zwObvf7b+LvTxQw4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CuhMQyUp;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BAA343B79;
	Mon, 25 Aug 2025 22:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD16C4CEED;
	Mon, 25 Aug 2025 22:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756161526;
	bh=V3i7T9lT07bOL5BbFwOOCL7OwuJkih0vx0CRYju6Zfc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CuhMQyUpQXFe99MpbOgyGc6ceLTzbIgnEcgAFKhEtI1cgd6s+Ntsh4Q0mlJLZyNek
	 kSbLRYvmVNeE3ooiD5/FJ9bLyweFYv6q/51jTvx5vtGgPlE82FKuAzQdF7RsR7FLdD
	 D/JYbb6T4hP0kySuGRfDK4254+PxRDU/KRuudkaM=
Date: Mon, 25 Aug 2025 15:38:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kernel test robot <lkp@intel.com>, Rohan McLure <rmclure@linux.ibm.com>,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, Linux Memory
 Management List <linux-mm@kvack.org>, Andrew Donnellan <ajd@linux.ibm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [akpm-mm:mm-new 216/233]
 arch/riscv/include/asm/pgtable.h:951:36: error: too few arguments to
 function call, expected 3, have 2
Message-Id: <20250825153845.eae0ae269c3f28a18e7db069@linux-foundation.org>
In-Reply-To: <20250825200715.GA598466@ax162>
References: <202508230551.qiEQu04P-lkp@intel.com>
	<20250822150906.7a6a87a7a8ad69f2ad67c817@linux-foundation.org>
	<20250825200715.GA598466@ax162>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A250F4000B
X-Stat-Signature: 7bfn7jzyjwib17stkk1x94yq7pxpspao
X-Rspam-User: 
X-HE-Tag: 1756161528-95191
X-HE-Meta: U2FsdGVkX1+0tPRH8oUl6RyO9lw7INW15cmpaXFSUTSfZW9XkRGKWdi+/UpngcN4ckx34ym5io7c3kh5ANoMWoF6r9wI7ZBq/0KSvk2YZ6XCfd6U1k5OdEmpSRc0J4rAlcwLwtFv4DW/RNwGvtZ8kP4XUV1Beo+LTbN2lFGkFjw4eDS4GtmM+t4RiAiBUfH2VPQJc+naAI5TFYmcn0tdof5gNEhYkpxBPnrn/kcjsP/uih0HjoRrt9UCHrCvj7zgU5MdOE1RB+JIT2R4gkIQ7vtCXd3x332vqazQJ+fbRiEBeBdwJKinRkqvk4bbP+CvXXn7pnSsigkOCqEFXjvGY+Lulf09gapcx/hd0XUsH53DCLqfakrBfOfa2lK3AY3TASk2QfTGmOTx8xovfzev3yz9qvokMOF33G33JkMCgsvUDJt7VV+CuJooWr8mBcpb+MXP3dZLJyHQpLI5NOOVgG4xi66aqnXGWsu811QWNzNFbmPl0MWIGvGtLSvbMWOaoJWVzp9ZmPsp96iEpjm+5gPzFKpP1YhFZkp8GaDMNMzfvjY5WL2WPCvfr3/g+UZmyv4Ddpep/GrQi8eynhcx5kq9MVkJtU4JAVNUltrGEF4SOmVvJmp2ubn9n6JMezqaky7nB86IKY+X/Rv1+QBfbnbhCLToFt+X9NSRm5LldZOx9ePglD8dIyvAVWKz6zvGQLRrFgiUQ2qn7UEPJ0jXQ82R3hJM90AFOXW40ijL00IfcYLaS3Z6hOKXASncgC/XoTdXa8e2lZQNRkQJvNtK83RaYfEGc627r521eyM4cpvrnwR4+9UUBWOu4OqLQjsimvXQhLuVp+PdrSyzqmp6eWQyBJDqtjxC52XNaMANstrcRg8OI7HdGcDJt9aldlBhl8L2XQM1itz/I8S6E3JTYf/eLbsFTsSjAwCX6irAZdo2WvIpwx2GeN5/Cw+TYcL/sdgMXrG8jDJdZ9g3Uh+
 PPKiIU58
 IpOIPLf2BmYOXCwHQ0+w6nduUTIN00CNaSv+XEvOfkl3AWsz3TBfXZqnv0EOmp2zZoZ+wY0rcYOaIncfYcWFRetICTxYkkrvm0RheUliHFVKemCu1jqiZsoTEOjZLXABLKDJyiMY+HCzXXKD3eUNsCyRIClnN2qedXixUrtf+fewtAMf6kLAKjMRFvoiJTR+B3v+NU96FxTCjzXgupbkbcMXCvP8Fl5tG/FSTltjoZKtFNmRchugO6bMpQvvW/ww9cmOijMyVAEYfmyutLEfOQSVqO2n+8AesSN96BhI+t1RdJ4aFuESbDk9iQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 Aug 2025 13:07:15 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> > > All errors (new ones prefixed by >>):
> > > 
> > >    In file included from arch/riscv/kernel/asm-offsets.c:8:
> > >    In file included from include/linux/mm.h:31:
> > >    In file included from include/linux/pgtable.h:6:
> > > >> arch/riscv/include/asm/pgtable.h:951:36: error: too few arguments to function call, expected 3, have 2
> > >      951 |         page_table_check_pud_clear(mm, pud);
> > >          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~        ^
> > 
> > Thanks, I added this:
> 
> It appears that this fix patch was applied to the wrong patch. The error
> is about page_table_check_pud_check().

blah, OK, I'll drop everything.

Rohan, can you please refresh, retest, resend?  Against
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm's mm-new branch,
preferably.  Thanks.


