Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E605CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B804D6B0407; Mon,  1 Jun 2026 11:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58376B0409; Mon,  1 Jun 2026 11:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E6B6B040A; Mon,  1 Jun 2026 11:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98D516B0407
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:08:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43D74162716
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:08:56 +0000 (UTC)
X-FDA: 84831676272.23.B3F8A32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6F82D180002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:08:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeuZZPxx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5Qn5lpRNTlWfCeo9CMrm9V3sYGYVnchDqXtweZThaQ=;
	b=Lkb+X56+xVo2syYVdzXhD31SOYQtSCJXtjiT/LMMsVzeWTr4RK56eSQrJPN7BUWH99cYBZ
	jscN9/ZrhdXkfXmk+gfFlW43lI0dJbtxGDePBBAlWcWzJA/ATGEPBDfekrMSFCDMv+Q/U8
	MOaPzYu5x80Nz6qzDdrI+eJArdKW8Ys=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeuZZPxx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326534;
	b=wjzpemobwTQq2C0EZNlLNVBvgbs7JyGiSEU/GseOqHyNa2gliIxyb659arOVNEszxn1SqX
	gNjNYoAxcIEn40fwgAOJxMGlpKSq/TSDfV+6iJj1mzZqaM4I/kW9ff+JOsQ5zlyg1pzSeH
	IyNjglLQk7/4SwskL+eszDCanzakeP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D27442A90;
	Mon,  1 Jun 2026 15:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDDD1F00893;
	Mon,  1 Jun 2026 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780326533;
	bh=v5Qn5lpRNTlWfCeo9CMrm9V3sYGYVnchDqXtweZThaQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aeuZZPxxFURTYiKzhL/I4zvy4RbPa78mKb81D82gqDtTLqUoqXZNkOJyrFkDKpfwg
	 AMi3fdav/TAlTdFMzd7i0+J6Q7tgA9JjaWBVOjCSK0kpiFkvsbYv4qOv/+uPTKlwcK
	 3+xlyZz8netMGLxF6OMKeJ1szM/cyW2rsgCA0uRxOzIIM/Jka2AjLDWHrWFL3byHBM
	 w50tHeJqGSx951jvjZDv73SoajIw4pEVyqmHvhrUyrqycZSY57FoZ26thYw20UP2WR
	 /1SqxTKrcaZGDKFn6ERHO+TsIBdzHVU5OMsq0rzYSPu5oe3h36uJtyEOH+R1WByf0S
	 3eGsvj+jm0+RA==
Message-ID: <99add59e-2f4a-437d-b2bf-301c446c3892@kernel.org>
Date: Mon, 1 Jun 2026 17:08:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] x86/xen: Get rid of Xen private lazy MMU mode
 tracking
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 virtualization@lists.linux.dev
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
References: <20260526150514.129330-1-jgross@suse.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526150514.129330-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6F82D180002
X-Rspam-User: 
X-Stat-Signature: hitgknxumokx7o6xcw9ucyj395zpgiqm
X-Rspamd-Server: rspam09
X-HE-Tag: 1780326534-173736
X-HE-Meta: U2FsdGVkX1+M17O3UCJ/kSObh+GScLLiDIKUb91swex//dYLI5DmOg3kNwlZKzPopUskZq9Z9Mzb7lBnK1D1+yYECZqw/snfCs5/UWSU59VDgz4vfWLc+S/UslmTz3z52sjGbgnDoyE52WOCbIRGW4Bwt4AYeWUZWkhWlkhT9eZW81M9/LjmOxiV8CR2YoC4eEQNhgxL43hM6qNNYNTZd4COZ5Y2rpzMPJ8djtbjPU0tO2PTc2eglSmDFugqH607ZmbsogXFjj2xfqPtvaqOpdn8Hi4aDaZCMy1edyCCaFfgUWVK0SLZZ3gWmJ5rzahmRfQ+tsxRZFsknWMEYJeRVP7/ldKbBcfQ1bvcKrx314aUrcPtjYVWpbbaVLne8Yu64TyIaO68Ue1G12pK40vwEW/oyGrQ1gVXSbKJMVy3qTWrApoHDrVzZmhGuWQd+j+3RupLl/lJY+Nmlk4Qg4aaH14tq5ah5L14tltwrpgjsSjblg+vPwtDxjx40rfurpkVMfgGWW+rfbJSCQniVWcvYmUTgydxJUYP6r8xywFbpLTB57KC72JPUrg2VzhmednOL8SMDT7ccvVGiD9B53PwTDPZld1qetQ3f5oUZu4wr4WhL9SYAdgiBuScXKsviWfcDG6frGcQsSzyDRhWlikMim33cmj1tMGb7UNZIGW03mGYgSpgI255uVGb7AstUMoAUAE5U+8wA9jGnOsWwfNnZKhcm5DZtgZ/r86/PXjtdgalFHzBeqgtdmRNjQ2+E3bjU/TZjpdw5jrrniy3cFyVOck7HFWIqThmTfN/Z3X67s7JifiQmRyhlYUbJyB9gu5jp53gkZViPdLjjIU/2CHAx3MP9vnpT1CM/Zf3sVaqnDBAPvjDsyYCbPlT+1X65tI7Sh7/bfL5KiwHH8ZfrduvpLA+++PpE2jdDwIALDOFYmI0fc+icoMAR0LGeSrFhuCMCBOAtpZDSRE3ApckPD3
 Q7ePACUP
 +Utsg4lMV/iaMis/ASS92cnNhSCeR8wh5JL/JxCxgbk7PWEJlM5MBIaW5olWH7EH5sJWXRCx3Sb06XsR+hwrvdwEVMHqzkKqwXV4P3lmKDqX1UjwovUJdBdTH4Db9UntdU6+Jynp9x+TUW65tvijbRjvyvGW6mobaikdWCh/tJpmg2QHiaTe2XpHDV2YZsdA/45zmbq/Uy0JTg4rQ+NmkkyfeUSpwuBmMu+0w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 17:05, Juergen Gross wrote:
> With generic lazy MMU mode tracking being available, there is no real
> need for having Xen PV specific code to track lazy MMU mode, too.
> 
> This makes it possible to drop two paravirt hooks.

Nice!

-- 
Cheers,

David

