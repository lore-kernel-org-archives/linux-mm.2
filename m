Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D26606A335
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=atomlin.com header.i=@atomlin.com header.a=rsa-sha256 header.s=purelymail2 header.b=JaRz1fVk;
	dkim=pass (2048-bit key, unprotected) header.d=purelymail.com header.i=@purelymail.com header.a=rsa-sha256 header.s=purelymail2 header.b=I4jXZS4T
Received: by kanga.kvack.org (Postfix)
	id 9480B6B0A73; Wed, 25 Nov 2026 11:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FB16B0A75; Wed, 25 Nov 2026 11:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834916B0A76; Wed, 25 Nov 2026 11:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 607C56B0A73
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:21:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9C2BC0FA9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:21:33 +0000 (UTC)
X-FDA: 85474156866.06.CC0E6BC
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id 22D881A000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:21:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=atomlin.com header.s=purelymail2 header.b=JaRz1fVk;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b=I4jXZS4T;
	dmarc=pass (policy=reject) header.from=atomlin.com;
	spf=pass (imf19.hostedemail.com: domain of atomlin@atomlin.com designates 34.202.193.197 as permitted sender) smtp.mailfrom=atomlin@atomlin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795623692;
	b=HMNzfbkOq6gffKXweFDtJU0QWPqB9IfwvC2/A5GC6qdT7P+kY9ll4/dWElVCdUEBb6K7XT
	FbZtaNNAfSOuZyn5kI7f4PJRZvhtAsiffsNrGyvONxX/YziuWC+Ngp6vnn21f9uMNmWT67
	hmElGKu1JD30N9Wn4UU9QgX9kYQ4giU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795623692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRMctCIyHFl/rubK1Zvyz0tzvLwm3/RXHacDMmrLKwY=;
	b=pXcc84wQ+6u9vx2TVUqIbjEg0oghOMTjeVMHHTAnrj529X63Tn9E46EB38m1a7KT4/4nIe
	hoaUgFblZVLHjnkVkIQk2JCLyakv9SsUJBLDhIpqvDeYBb5lwxaRwPGiisNtjNjlk0vEx8
	5c3Bef9vz4m2S2piYurJTnrSLnrA9Dc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=atomlin.com header.s=purelymail2 header.b=JaRz1fVk;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b=I4jXZS4T;
	dmarc=pass (policy=reject) header.from=atomlin.com;
	spf=pass (imf19.hostedemail.com: domain of atomlin@atomlin.com designates 34.202.193.197 as permitted sender) smtp.mailfrom=atomlin@atomlin.com
DKIM-Signature: a=rsa-sha256; b=JaRz1fVkCfMLTnnLV57pzTTK1Ne42yfaj1IQX7jkKpXoYRm2xfPAeUWitfuGkVkuBkYPfwSQi6GVts1W8ILi/8fKG3fd6woyrygZcvrYMGO7+Fn2m7PsE5NEAAQWDIe8LOPCpFTgKzb+37wUWO8o3cB/9juGJGuBJnrD6oQBmjCT31iFtD06jOAPhhADuPk2K1hJ1TsZXt8Qc5vvB5o68ViOziNwX6cg0TC/LADlzhNY8k4yJwlinxgWIBmNZn4+GpacEOD0UoFqxgmRwPcJ3HE/Q0RFp9wdO01pC6fjTgJW6+iYGA/Lp8ajKzL0zrgJzKFi/maclLHm/2t50hCoQg==; s=purelymail2; d=atomlin.com; v=1; bh=JpXvq6kgsv07UGUTorie+7FWgV7cwV+gGchX02qK4cs=; h=Received:Date:From:To:Subject:Message-ID;
DKIM-Signature: a=rsa-sha256; b=I4jXZS4T8UIPssnHu0O3SGNngfH1JK0VCZY2wnvzTqpBZZkwIKsLrgxuFaCz6RFMXLvZVACSGPonpZlXOl03dO4uxIlr7kANcxRRizZp5ka9Me0Jfp7YIsQrW1fvILuU2VN92x6pDsgjQYYnZHVvnU1PmFtKpFsQf8c907Tbiwm9c89SXcKpiCt+KCjq2LcK+C6LfPSEz0qgPjS7PJK8nhfDV0Vv9i6FdgMBR58smK5k4ILe+4mXr9x9v6ehlRFk4TV5u3ZYV7kHxxW7HNgu42hvDGvau202rfSyErr6hQmyAzb1aArsuZUk3f+1ZkSmkMIsEyoEzKy4uChAJe5fDA==; s=purelymail2; d=purelymail.com; v=1; bh=JpXvq6kgsv07UGUTorie+7FWgV7cwV+gGchX02qK4cs=; h=Feedback-ID:Received:Date:From:To:Subject:Message-ID;
Feedback-ID: 1802931:67223:null:purelymail
X-Pm-Original-To: linux-mm@kvack.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id -217530310;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Wed, 25 Nov 2026 16:20:17 +0000 (UTC)
Date: Wed, 25 Nov 2026 11:20:16 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: david@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	rientjes@google.com, shakeel.butt@linux.dev, sean@ashe.io, neelx@suse.com, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH] mm/oom_kill: optionally log victim command-line
 arguments on OOM kill
Message-ID: <4gedpy2buvhc2urtsabb6kz56f4s3njwvjmxbd4whpz2bvgv4s@visad5hfhylk>
References: <20261124205043.1010247-1-atomlin@atomlin.com>
 <awb6I0qAySbhBIsW@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <awb6I0qAySbhBIsW@gremlin>
X-Stat-Signature: 9iqyh1mmwf6brghd4jzb69p367wfae98
X-Rspamd-Queue-Id: 22D881A000C
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795623691-656738
X-HE-Meta: U2FsdGVkX18dPgzFhTag2+mfNxYvtUUo1jyeS+iQdje4koHJuGbJALSVpsJAFu/AfZw7Btq8WWVEedQtSNqGAjWCaek2GxGl2oKMSdnV4IOVGeYTI0Xaj9IX8yWWQASYljkEKneolOYKbG3OdEyfMlzWSn/sDsgVA54rGLRpBGpEe6zX0r6fyT+5Ks3SsMvqIDFP+zATJ8DI9aCehBnFIOaiCgRAW5KAIuyJKXcrmPOrtFR5Slm/IFXNT7LCB5hZgVxb1rSleCKOcj0TuQLioFQax0X2jcj/XKywfLODugY8nDpyA3+ENKfehKegxOeMGJMxOpT2nufmwuMts40iHKH+zE9hQXuoIqupvK1LVaRyY1LMY3iollnb9+8RUh5dTrVv6DXqZtMbJBFqeElNesRxNOVtooeBJa94qYfs4CCF5hRsr03aZOpg/oD0Ie7Ay2s1braIIkA6KigjSKJRFjTZDYbgs/KtOs+gdWuGe5z/FVa6OagbsYJ+E3InPfeD1fgvNwsSp+HtqhAFP7o0gt0MJ4/uGhbcv2FFWlwSR6ZUT+u7Ham565USTN9Zp6KN/EBatkpxkx8csA6eqEus8ghupNwQCqyJMrEtOptW0d3uTYcjpwRKck79v7Pziq4k3oVOkBd7gwXFtJsQIV/juyV2lNEi4NHfyq96fJGyDEKgyO5THiMxkRdXd7BjqXvafCWZ50Q6y8Fg+wDiVDdAZWkoiJhJza/JMsO0rgpqIDLMT6vnM5Q56SEJruCphMMVWDq3IvLTEHYEXoTXJR1uMfp1lxAryWu+WatAwi/IoG1gvmHVoQnMgoDwzixsgEC/DAGrUvzRRdNuZnOqbpCXAS45zNqmbH4bOUPMDgIrBLI9mw6sZsIHC/ps4cn9Gat/L3e7xxs6NZbFcroIcicOdNIJ8Azlj+FJTgUr8DYSmm+6fq0hw2hLVDPkxRAO0qmtnY0hJOYemjMto7H+6uQ
 UJvn92L7
 PNzoTG4VQET239W7RPL+f8MI2cQgv1rFxWw2GFl7itVx0K6rNrdxDVdKtJ/5Dlq9zvuJVVLvT8uzLvjzjEem+uj4IBEtxzuGFifql2DuuY5AMKicBzERyldbJViWHDuO1HpyJvokRDGFovW1eEwVl4EWsKtmSyLK4LitLG5504e1eR4ZE3FAENCKbSIpBDTmqN1oifx6la0zpiy0otp5TPZ99JqjpDuxyY6eb2p8w1haRtUCM56asOCCLtcuPBCmqbTBx6AB/yWYu2vB/BLnqq/fzRTtpcYv66kBnj2q0Hwxuz9SQbym0Z5phPfVsKnTRK0hiUKFDFLwibRUC7HYQP7tVyhQ2GMyV8jiKOXiztaZTx7DPKJ6GB3B7Ku+u42YrmxDZZlIOckaM4VAd/glZdscBeEvHoBkzyps4U+HxgdaOKB6l/99XUN539iQa7snSU8bMK4wG0nNvG7uKNcpgrRm122IzGK+abc/YCSk8Ot/1tgUs3q0eI8sObnAlsxzVMrIH4mAZjy1zetFVeDhMsjoUTHcwsJYMzHhm+eOSVbVYKMXT956Hb3fdQ3AE3Q520sP6lx3ETNeo7nF8z4+F6N3nGykSsxSD/ezY+liI5klj6FluAwr3aflaeaT5BqrIvLOXIrEfr9XlCMz+OKR+4F5Cc1lh1z4VAqkNa7+27+x13zl75z2/AMNE7nQe0roEHPyD+4zLrdD61W/qD/Mb2zeKsCB9kZc/UdYZJLXJk287Ulyce3BrtAvx1fGqZBcXuG3L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 03:33:28PM +0000, Lorenzo Stoakes (ARM) wrote:
> Nackity nackity NACK NACK NACK!
> 
> This is terribly, horribly broken both in concept and implementation.

Hi Lorenzo,

Fair enough.

For context, using mmap_read_trylock() before queue_oom_reaper() was
intentional to avoid blocking under oom_lock, which is why I sent it as an
RFC. That said, I take your point: touching mmap_lock and walking page
tables via folio_walk_start() in __oom_kill_process(), along with the stack
footprint and adding a new vm sysctl ABI, is the wrong trade-off at OOM
time when dump_oom_victim() provides memcg context.

Thanks for taking a look.

Kind regards,
-- 
Aaron Tomlin

