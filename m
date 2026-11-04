Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45EB606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=K/zKAbwk
Received: by kanga.kvack.org (Postfix)
	id DE5C66B05BC; Wed,  4 Nov 2026 18:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97746B05BD; Wed,  4 Nov 2026 18:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BD76B05BE; Wed,  4 Nov 2026 18:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99EAC6B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BB6EC08DB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:38:47 +0000 (UTC)
X-FDA: 85399053894.05.A94A2C0
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 18ECD140008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:38:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="K/zKAbwk";
	spf=pass (imf23.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VoCFEISjEe+3bsOKsg9RxmedHt8FzEUYGSYFsiV26+U=;
	b=4SW9UbTKqaFrdIWPMoMrDPz3DXXDz4TLlOPzTcKYaFVGlKorAaSrC2o+yQXH9JV2jRgY9u
	3qhcjKXEPzdpI5qAZU7KEzHXOS7ksANEffTHadX3Uz2UDkZhwOF4DTI7yd1HI197dP/yGH
	Oa+PT4tCVgZaA5rqQ54SLYofHya/aKk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793835525;
	b=uCeQAdbHhj0ShyNnybYEpCsW++RSrv1/v25fi8cIZxLi1MeFoOB0JJcpGBhAy59XSEnUfG
	0U/gI3RV8N2csMexq1+MRCX/cdP00GwvZ2tD8LCLMSAivuDbQCRstXuMpoWje137ebV+8Z
	m4VA2cYAgdXGb/M790anWYgDxj7RaxI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="K/zKAbwk";
	spf=pass (imf23.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso225059066b.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:38:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793835524; cv=none;
        d=google.com; s=arc-20260327;
        b=k394TX+cQJPIshDpoHIUSCVsGQNZ/k2ia1ftDByowQiZ2LmnJTjZVmk3g6iC7O79wz
         2PSxbfx2RVvzqAaZRAwfc0LdRyEGqCQkg6al1i6lGWrgt5RDBu12ayREoxvKRA2jASni
         5ma7NrR6YQsjpoH6hKTFOYApvVCVviMhb49ll+nND108iXQLK1zYohpcrILt9KJprg8G
         hObj8cL7KihrDkjvTp+xH2A/mIU0ENGCoH7f5p55VW7RLCetlqXC4oPniQaOLg9gChHZ
         vZ7URD38hvIX/HFOV3qU/6MnU9TQnzPQuSQEuyUp3rUFVWEKfADy+ysv0tO1+w5NlMsM
         UuSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VoCFEISjEe+3bsOKsg9RxmedHt8FzEUYGSYFsiV26+U=;
        fh=QFe/tdiTtr+z66mBg6VaEiAuIInSpxlSIkV+xY9dg9w=;
        b=jJ639WcJWH5UzMHH90ZvaZt0cPqHARpQ26p1mu6FbfIu6j84BfbDSo9fd3ympfyG2a
         g8c7QekIi3PHChSQ4xuGrJv0bOlYf7F9RhXh1svHbo+m5HYCBcEyaDs3+GpMue3l1VPp
         QgmYeNRsrn9LOnIMbj91c6+RbE9MWCGvKc8tYVvn2VDOTqHI1x+YThFuf4cvhBfHTMQk
         33AF+9fitS+L0txAJ8PvYA8Rce/S42o8ERWa1UXcSU9J3kFJ5VEW6ab1e4T4Bd+tn2n2
         JaCkEKz16lah9oowkFq7z24KXckijxCrSWPuEf2luAIjZ1wl41qQoJ+FsVYGmnnSM5Vz
         k+Aw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793835524; x=1794440324; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VoCFEISjEe+3bsOKsg9RxmedHt8FzEUYGSYFsiV26+U=;
        b=K/zKAbwkXKW3alR/QgajMRHv3zOAzKdrHF8V6PR8Y33wv6CzAnhZwO9EwACjlySIfl
         6C7xz/d78zPE39Rm0GQJROuflkAlDK6eDHp25Nl+KUh1yDfgTUHc/bzRVUblZyyESKht
         h/fQ3qp71dbIlXAoFICR/l1FVmjI0w/xPYor3UcJ0GYxK5uau7u507xQEAXO2yvftt8g
         GiisOfcDJwxWAL2zalIWZRDXAt6bIPmK/LwWUdSDRcTR+VYgW3VLPLyJ9RUcKrCx0QYL
         aJz9rbZPhdJkUSnmNX6/MPsCnbMb+SkkGmgWv9iBhtjJ+e3RVejVjhG4Q9/QBlN/XChx
         EBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835524; x=1794440324;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VoCFEISjEe+3bsOKsg9RxmedHt8FzEUYGSYFsiV26+U=;
        b=hEPdOcYJ55LxGBypxauIHyRRo5BFKVvsS6XPW1+T8c7CwpIfAu1YqgDQR3hyb3v1df
         4j5UaJ21dKeRsDbp6jxCsGWH+l5hs8yN54M7HuJAqhEtCNPcs0PZ0mfZmj2YK4D6cWtL
         zFlmIeh4vqU/soDSZrtJCk1bJSU4LdG85ZaeJWnb8PG8P2/aRTIoM4QRsgCy4tovCRu/
         QvrfLHlwHQ5YBEFyaNWVnRNZYolb5X6B8rEseAY4NA6Vs6ktSj7VkEQ/EJUxdKJUmmL7
         /QUn35J/kLt63quWasPS4JQCyC4SL3kI3au8JV2aEM/omMmYkjtVCfOwagIsBDROURdw
         K2QA==
X-Forwarded-Encrypted: i=1; AKwUvBwhHWoXeIoPEnZgCb5D2I8t2vhwhZ7FAzcJRR9OhuT//TTLwx+c7cpFo3PehSBYuNgjydlHrMkuqg==@kvack.org
X-Gm-Message-State: APuU4Z9OnOe2hEvSDahpfmQYmo4MQ5dGc3PxBoIatNMUG+SpOtxmQG0u
	kT0K2n9CyawPgcokiAYVTBwbhOXHpOCTepAC2wgdsVv6/dulnHS8mdbWgNsRFn9zNMYebWwqBam
	jN/KjZSvzyQwXvbSss1hnMT2m4WxCbKicZykHIz/A
X-Gm-Gg: AYBFou0bngLrckQC3lKFjUtlFKLR8Twfvr7QYq2YxaMluN7BIdLWM9UDFncOSOWX45w
	ZnEEe1DhjYb+R+0qJ+Sq+insiIoWdbu0KuyfsKVjDXJHpW9zBePpzbDX3D17SnjMyClpt19J7bT
	Anr+EH7/YmWBawv8G9tk9iCYBDGgvqwr8jj2EK3fviU0x4v6FWMP2/J+nXI5lSCKFPmtGaNdsWb
	0rxZdEXX22gXF+7JUqtry7+jwywOkkUbe+GfqBk/2+WaWbF7CMnflXMW2WNCV3s8+XQC18I0J4S
	Q7sZN2MoNhlXrL8IjBXeBBxWcvAjW5kWleAAe/pr2vdpWY0ZJiNjqhnNBNkww2CNVENRFiD4bj5
	3vcpt8e65spCo3JNxkH0aY6lqPsKJuaVUwdKBPQ==
X-Received: by 2002:a17:907:9615:b0:c2e:893:7010 with SMTP id
 a640c23a62f3a-c4ca7ab1105mr1606291066b.37.1793835523294; Wed, 04 Nov 2026
 15:38:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com> <20261103010216.3447716-9-dmatlack@google.com>
 <2vxza4nok0ji.fsf@kernel.org>
In-Reply-To: <2vxza4nok0ji.fsf@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 4 Nov 2026 15:38:16 -0800
X-Gm-Features: AclHuK8g0SSTWzLAJK32VMTa5tPkJ4SYKSZ2JyPLhAu2cuQYk5IO7KP3qYgSUkY
Message-ID: <CALzav=cjq0FjSRe_KHns4sGpHtspVy-5DBdo6Kzg1TdQa1z9FQ@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] mm/shmem_luo: Allow preserving tmpfs files that
 are still linked
To: Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ei6g3rio596ijwhfk9fjsdg69co3rktk
X-Rspamd-Queue-Id: 18ECD140008
X-Rspam-User: 
X-HE-Tag: 1793835524-780572
X-HE-Meta: U2FsdGVkX18C59OwPEqERvkOPx9fPKFvKSrwG8L35dM6UKygPYKjxJgycApWduMzmpmFBFqqLDU/8Q9TpCbRi4AmoUrxxUCLe3/zz+9yeszfXj1l47iWhLWVk0MmOgGEKp9TWrWNQ+it3XnSfR3xjfPa8M2AqJg5O1JDArPxb8I4AeKOcSORogYyj3pZAwaZ8xVO1hSCUzijtQ5jy/QKuRi8bwBkBFS5eN+Oo2oxX63W+M/eVynRgBP7emiDiU0n5klhQaa9ILRm7CfndPOkyt5jINNpI2Ul03slS1dNmLYMEU7qt0FMDchvfQqWNgnpFJLh7hF7jvoLrnSgSgrmnuSzDvBmVHYEmZjxIOnjJkRKQDWOZSWZJKa7qKMX0wEB7vYFs2zTdkadb2OGswEABdOjiZpAOyILtSTItDCzfc7GY6cg0vai7b0eWbIgXi3ocvrWkpg8NDflMgp4DAkIcu4c1iGbBxKGPbQUrHYMGrV+BR7j+BTq/4L83iXADPp8c/Xg2ytpGqyqx1rT2lgFvebqdPAQNvZSCki58J8UrjlsbeaPhh//tlvUvlFehsKLiM7JH6yjU/1t2cVan98XdmA/fBtnzaBecLbW0ABa1wdx+QHds9yirv4wR3KWxToItBCQ7HbBw4mCqQSfct9CGT/2slEtyGZJa0tvpMXFFx8IYmK0FQZtMb6HvurMx9DJ6KFzwQiFkV5GAvJupWsg2DBEHj5Jn3aqeib04BSn8QsZRzZn9P9cWSt/MFlbXGh6ruuEO6DdtEQi/XsbpBetNXmpDuH+LXjiiPhSVTlZXHtd3za0a1xdFyV5ABkV57afUfwXcxJanWq5RHo40VmSXECHTBtO8WESGmjMG39rmk2hYBuFhk9tZ52xBcnRHaUrOPDJZXrg309nFj9WZUWQiIREGtSs8bKrD8z/zzyBgHgxKcjBpe6Y3D/GUhh4jATdWUtu19OMhexG6k6mB8s
 M1JiP88B
 MFuryPpoNIfpgEy+UO/xoWXXHOvIlscDJLQVK4uLOXNPGK9bMMDMVnQnA35tu2/qOWjixMY16/7ZKOey1HBM1MQH2blJs3yic31QYsAI/leYChdkquOKN1YjX9pEqOicgOrUzRNdk6N9b2MvDkVnHa1HQ91D3nxA51MOOgDn/g4jou44NPLzApENH6gbeFJiPQXBYbw11uk/dg41XRnxgIYNkKdzi/byKxYY0h7qQOJ5yDV2r+H3ybOwe+qyuKh/IE7Yhw1FZpV7iZR6f7RB9TV/TCFYXvvHI6Hj/2smho25roQVl1vmp1wobhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 8:46=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
> I usually spawn a subagent with clean context and a high level descriptio=
n
> of the goal to review the changes and changelogs, to clean up these
> things, and then of course review everything manually.

This is a very good suggestion. I'll do this for all my patches in the
future. Thanks!

