Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D9D606B0E0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qnp4nuoE
Received: by kanga.kvack.org (Postfix)
	id A4D266B05CC; Mon,  2 Nov 2026 09:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25266B05CD; Mon,  2 Nov 2026 09:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939E86B05CE; Mon,  2 Nov 2026 09:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73C376B05CC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:25:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D34A160137
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:38 +0000 (UTC)
X-FDA: 85390402356.27.D5AB206
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B55E100013
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qnp4nuoE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRCWFpBz7FUgfB3FARLk2m5vQjODJMmPqdZnqL3DW4o=;
	b=jnDRCbN0lhBR285gYVqGZlmYd+8Cz/E5o7lmuw+BZuq/fDWal3hHYbv5+61j2esHQNGtYR
	Vb5sNne4aMh33/SrKkKL6rCq0WtT0jrw7qA47TmoccRJ5qc+kARu72CN54L0pAyIfC5CwL
	fVRqrDdxqWr/ExhBOUph7fZLqc10mHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qnp4nuoE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629536;
	b=j7eEEqpYaqksvuXzHPDhDf07HFHHG4XG7xMYQ5d+ni9a1ZrknOWfOcZGeLKdU3meut4QBY
	u0Tyu88ew3vAmi0MEEu6Xx3AIuAzXuF3+272X/RZEJdH3TSvZoC0cHD4vYJDPiI0QLtREz
	l1JibROHSIV6Ka6GwyNQjx9+gwQjb+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 176856053D;
	Mon,  2 Nov 2026 14:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9356E1F00A18;
	Mon,  2 Nov 2026 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629535;
	bh=sRCWFpBz7FUgfB3FARLk2m5vQjODJMmPqdZnqL3DW4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qnp4nuoEfk8SdEnmrUkDHhXQUJXar6SX8Pi/DJVfadKNXU+/ctRAHnZp8dZaCRxAw
	 fcYb6hZd1zRLPUMakrEKVr0sOc7ajeDE5Izdae3NY1zvrzLlN761lH3e4+fPxdsTRU
	 CxkjDup95CmCwWKMw0/+xp3bICK8mdacJAN6HZJZCAVzm7Rc4vbgGBDPZagaqjZooQ
	 nieDQzA6NqrKQXFK4LIprqJKLKd4AcDQn3nuLVlLQ0CjQFRJblDxFCxTP+eQ7meUWj
	 zlD+6ugLz8L6ZAbPh5zuzDxjfOSL1v2LPhUQRMozZ7TzLTeP71yNW9B831St1pJ0na
	 9Wiu5/7EtuXlg==
From: SJ Park <sj@kernel.org>
To: Wang Guangke <gkwang@linx-info.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
Date: Mon,  2 Nov 2026 06:25:28 -0800
Message-ID: <20261102142528.27792-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <auhgJ74TeQOIvTtO@DiGouShu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B55E100013
X-Rspam-User: 
X-Stat-Signature: ymsxiqt5a9e7ys7835wuno93qt54kt4s
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793629536-759549
X-HE-Meta: U2FsdGVkX19BME7T1Wz7MxW/1ljgq72mO3OYt6q6JOzdKBk7fguP39McV/w6X9zT5NcJsR0aYlPT/Et6T4LHnhuAmXUl+rxH6uC41cbckBxXSCjegqK9HdsLNU+EPGpAMqBMICkxUI0b2RZGvWOKmVUAyn0oDAHQ+KEB5uWdAST23jJhTpvD2fhMVP5BqPqGm+3H1Ubb+oR0nJp04awGMdY7N6D0bjXYXxqjeX79S/gG/kJhP82MfvtiE5id9BT3YCG3fKACmCUb6VAbuNifd7VTzLTQa9BrmtFnPExKri4SNeS4FFmcS5HFwUBs9tw+ZZWYDdfrhKCiV9maPFmPdbN9LtSggKjKgjg41f+dJec5jT7jyQ+dVc9tHUCoAhBzWwve9V6LBE+L/jY9V5X+FFoLTT9jK0NoDkUoloIlLyPcDyWTDO7MI2v5ZHaN2dkQxA1TF0dcci1bDY6SVXYfrwnOnD2xHnNVxoNVH/m6EALJoO6Anw71qhZnaJIoL21p7CnbnrThOB5rbQmTZstKXR3iMVJFc1X6X/IlMVqWoX4wogWMSxrTmDtMf3G1c+OCqUXI7BsZoGR6bdOwrjIG+l8bgLxzStEu7vyx0BHQJ4q6STG1zxLCNVrj9cGe0ZX1quxveNIupIBuKxUXDWbtTeXqqIlkj5wfQ2HbnjkqqfShTzvAiXM4Q1ZWnYNH8P5JIrpJgt52fI+CmEukCcgJrHP8si49bpcrRd8CjVNh5h76kMgeGtOAzpdCTWR4OTEKqAAmlEYzKyPPtSXXRfgVS3nwkm+ZPyU46iSe53dvtqcc5fs3S+6/tM+YIGtNSreJLhA4oSIOc+Ay7FmSKHqlYk0RVeJIXAl5DNKp3SJnWhXmfcJSck7UPfjqClqHCsdv2u7K2ah5PSomvAc+9BIVlafs1CvOJGoP+pX46KkGgMBKCIytU3jwMeL/LGYi9dw8uXqG7ou+jw1ni4Vw1sr
 sLx8sQxp
 m+VX03S28nzE4ETichghWRZ8pP7leLRi4EbH6mYUun6oXWWFP0VJ868vFqiGjRxY/3udct3sOK/EeMfLPdUYlODnF+a7Hl7sLamqjWwdjipq9jcKJGkZ6HZ1oHce2CUSKxoXb11ZQ650GE9Hb5TWYFo5U/AiVY/E0WOqcsLQTu5Uj+VPoUN52srCnAMNHlHwu0rlsBEQ3n/AQWMwGpKKbFGeQX+D+WqaqPDkBLA7gtF1AeDd8pFoTywe04nhWwhIY/c4KP4VC+8X3WTkFqEvlWQSQZv0eG5fm6RtSZWJnoAVk8aepi3UYXho2tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 18:04:23 +0800 Wang Guangke <gkwang@linx-info.com> wrote:

> Hi SJ,
> Thanks for your review.
> 
> On Sun, Nov 01, 2026 at 11:13:43AM -0800, SJ Park wrote:
> > Hello Wang,
> > 
> > On Mon,  2 Nov 2026 02:00:01 +0800 Wang Guangke <gkwang@linx-info.com> wrote:
> > 
> > > The calculation of estimated_memory_bandwidth computes
> > > access_bytes * USEC_PER_MSEC * MSEC_PER_SEC / aggr_interval directly.
> > > On 32-bit systems, the intermediate product
> > > access_bytes * USEC_PER_MSEC * MSEC_PER_SEC may overflow before the
> > > division is performed.
> > 
> > Do you find this issue from real usage?  Or, jsut theoretical?  Could you
> > please clarify it, and user impacts of the issue?
> 
> I found it by code inspection, not from real usage on a 32-bit system.

Thank you for clarifying.

[...]
> > > +	estimated_memory_bandwidth =
> > > +		bytes_per_interval * USEC_PER_MSEC * MSEC_PER_SEC +
> > > +		div64_u64(remainder * USEC_PER_MSEC * MSEC_PER_SEC,
> > > +				c->attrs.aggr_interval);
> > 
> > Let's use USEC_PER_SEC instead of 'USEC_PER_MSEC * MSEC_PER_SEC'.
> 
> Thanks, I will rename the variable to bytes_per_us, and use USEC_PER_SEC
> instead of 'USEC_PER_MSEC * MSEC_PER_SEC'.

Thank you for accepting my humble suggestions.  Looking forward to v2.


Thanks,
SJ

[...]

