Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D75B608BC40
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=NsNTqHY9
Received: by kanga.kvack.org (Postfix)
	id 271E26B05DF; Wed,  4 Nov 2026 14:45:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1860D6B05E0; Wed,  4 Nov 2026 14:45:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C756B05E1; Wed,  4 Nov 2026 14:45:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C20D86B05DF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:45:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C59A160858
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:29 +0000 (UTC)
X-FDA: 85398465978.10.1DB2D3E
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6BDC480007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NsNTqHY9;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhauLcYrkNfZ4d386lPMrnU0qCgiFUOVmgX6lCm/lmo=;
	b=sozneYmKbTHC3uFUhx2HvlAjwoX/3UGT4DVjxv+bUkhJbshImeo4tbN3urCimnDg11Vovk
	l+FbNZp2s/53dvFqfWGdgohyfnNLOfmyaRrddzdcIgBpjSaesWEq1rL86i+URg8Ni4wxM1
	7EchSU8CyEWX/z++SGW/5C+dwz+lSGY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NsNTqHY9;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821527;
	b=FnVIcJzP98Xkz0zaFoTKsVuf6bI3brxs36VSw4Cxkz9QSVwjKy/NNY3q/Nrxuj08FeS21p
	LE1S7zCm9vFxPQvoF5/l4AT++3c2NScuqj18fU+GVHrCuvvAPoAqfv+C44sywqzux+IyQs
	ravpStFm/IIWJmAdWd+lGhM3qXuYJkc=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5eafa528803so391261e0c.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793821526; x=1794426326; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AhauLcYrkNfZ4d386lPMrnU0qCgiFUOVmgX6lCm/lmo=;
        b=NsNTqHY9GhAo9nu+M7qcuIcETPddjGzJkaT1dFLXr+vxj1QGAGDrVR5UUz1OOaRjYR
         GNKKAuUqx66TRRFaUHTFyCcftzKW7yJyGkEKmlccGaUMwmy14BTF0dGoBZ9qINSSphdW
         tg3deRXBh4vypEpkHK5+D3avYteBOYvuWTsqtsNu2hrWYCSStxG1ZKwaEDV5vtvQ4o2n
         IU+pwA74xyLYllRWn+cdDp7I/070E4k6fSOWX5HmOjHSe3ogF6etcYIdQFRMAr/dJFf5
         OjOEkVZ4V4eBRrDQeTDb15dfOpPxeQ2V6dyVqK4q9b5pUnuysxC/kzvBIDCbbcECV7c6
         I1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793821526; x=1794426326;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AhauLcYrkNfZ4d386lPMrnU0qCgiFUOVmgX6lCm/lmo=;
        b=aL+5l5+EUfX0feT0glwGmvsUilHxAeR+V3FJHtCdmb4gk6LsgZzyBqT1RIkJ5CDDpc
         +TG/Y0uscB9tmuZ91qHBYzJ3GErfhucObN4KBN5mzUmlZTp4NQqAjZKK3JFVX+/9UbF6
         nez6UqItytDXVULjoQ5Krf3cr5LMREsHLx+WIq/1GsVIKVwdWAqj1hDeWUWzYsXH0NQU
         1S/xDwPc5dE5B3zvb8Mj1IJtj7eXsD9vOvRCPSy7buxOPS8oyfZF4ZFhJh3sFhwT/orA
         v9xtPOz5tXC4ectRkJud3iPMVJk0zfKqJ6EHvpeMKKXvowukDsvGVWPJqEfyWVr/qC+n
         cbCg==
X-Forwarded-Encrypted: i=1; AKwUvBxnKmoA00cjQMk9+7Esc2QfdfgJTQQmUzaDuuaQRJNfcdpn7WUZYKD0rRPmESvPC0HHFT4cKRhVAQ==@kvack.org
X-Gm-Message-State: APuU4Z/m/kN4D170YwAEaVpMS5F2e6xqHy3WQK+1j3cUBlwX2coI+W2b
	jX8ifLN6Mn4uS6jFLbX0UAZovniu9nONppb6iGwUAR/rC7HUJlf5Bk5C80nNxWjeYK0=
X-Gm-Gg: AYBFou0okb0deftoB76/5qzaD3zkiQfsGaCYn7pcPqbYsLLDFdb3wu6bb9PRUrdGeX6
	7U6DFP52WJiXFmutyU2w06Ihq7LGSPAv9mKSGl7uZyuX996ze7fQvo4WGr/EU5PN4HWx8Gv37rE
	gYcITs32NweR5YKuPkZcBnKfGcyX8LMxvWqPsPA2WboNkIiwi3ZCKIejhJPbvNpegudbEgtgNM+
	li6n2jG3pKdBuTaYAVXTN2F4Do4Q2+tonzKU/tRueBKPPoKkB3rx02NBtVbG52GRD+7pHnU5t3g
	CPquRD5zqorgpAktivNOwTY7l4w33ZjCTOojuhHADvPfO62U6sJqEaN+npGf5ckr3LmzEn95Tcg
	RpYyQ06TF1zS5cuCOjzIUl5la6y/zWWUvtFA4mquSOLBhhXy2CuhBaCJUOjgd2WqdJHyMokhTww
	IN7YNYSMmN+bo5xwVFxNSCCp3VidRSGVBXHMGzm2sdWsvLEUf8snxibF/9nCQ9pzGUklstgYTVj
	bBnyXkhFBs1PXM4w4ge6/ZXR2hyws4PyBNz0oF/BF+LSeyZY1wLcRNxo92n8g4Aua3rqRu9DcyD
	AuEpw+D+62N9EOz6zeKHT5mUF79MVuysLWl3T32uPQ+bpFOSncgI9HCG6rnYg7GHgas1J2sFqBg
	BdcO3KiZLloBHt2kXSGr1O2/Xv0BQ
X-Received: by 2002:a05:6122:54e:b0:5e5:29f7:489 with SMTP id 71dfb90a1353d-5ec6899f507mr7074700e0c.22.1793821524335;
        Wed, 04 Nov 2026 11:45:24 -0800 (PST)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca889381asm2496927e0c.0.2026.11.04.11.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 11:45:23 -0800 (PST)
Date: Wed, 4 Nov 2026 14:45:23 -0500
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 09/10] mm/shmem_luo: Allow retrieving tmpfs files with
 O_RDONLY
Message-ID: <auuJ4msatqzoOrjN@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-10-dmatlack@google.com>
 <2vxz5wyck08d.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz5wyck08d.fsf@kernel.org>
X-Stat-Signature: xtup6xmsqd7u416in5tdifimqok935z5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6BDC480007
X-HE-Tag: 1793821527-597722
X-HE-Meta: U2FsdGVkX1/OS2i8t0Ltams9x24vE05ffFiDnhIB96WHdBehEIM4vX7FdymblW2a9Zn1xqVBvtOxccy1yYdTSYjzNPscM4+opLhRTWiShOLjfqOOYcnXvU4NXjY9lMjNnYIrvfm7/p0vseCtL35G58AAYKzsjfcxE5Rp7+e/ogoqFT4joMcOCZG1eUQdpct3fT4SbfOaFbbqHae75BZcQCP6S2VPWt5YwAcaZLu9vKnB5KckJ8bFliOYJeTJvJXiNyghPYWfXV5XPkgxGV4Pk6liKMWFH8NYd52UvVIcn375yqjBW9aLzHgBauQVmhESrC3XBFsQCBAHBSkFjbFWv7OD2NDW9ktJa6x8pCOmxIcDhkVEal3lvQcJ2VW6RJWJKEDdiaM1xG85QXVJEaCzR/fBgg9XBoy+r70ZUXLJUu2xzam//yk4L2ZEzMP90Crikwu4/LaxZrbeTRLc1Gr3TpM1oDSWYCgLZHDefM7cjbuMNMqFuL6SAm4yqNgaBv1xmQC+0FqbfvfEXdsAnaQ+Lkbz08wF8QUv+cObQkBC+yoOlz/iOpiScbyOCDtkPE/xptcXKb/yncVKzbCYK6J60pu/o9d44B4cvm4pkjzjaf3N1fwyW21jjfPUdOI8Yyutz8AJBpsE19yYUGnjCmhL2Lj097+K3DtYs1gP0xqB97lkzpLMcuEK5NOM4Q0YKUHHbiSd924q4uN2iAXEWtFJoQEaDcnn4qkR6A3MWaJsNhfam6uUl/7VeT7yTIMojzgviqRmWzmfPyFOKJqNyNTav3rcUzjoaXb/OWZb21WY8WFCr0fzwfMsft94dDpQ6AyjnVmZZ88ZWjKAzsGaAN01FW/M0zMabk0lFb6917kuaghXGvFLEVN5xArr35d2wXlvuEykM8LNpz6ZfCtYfyTPyKykviQRlJVnLtrZuYF3RZMTQAnryVd25Fe4qYwPBdlCe7kAzl7/GB504yJKZ0K
 jsTTcksP
 rrhR1BuRI693KlPj0Z9att74TpqOkXiCHEC1zacVYpmuvSFpDYiw7KbBoMXlMzQ4I/+DY5l224sgA9F3pabl47Q333nCdEy7bUIvqNd+VOU2gBqcD5XFEXJwyWM0fppRq03ZfcnG7x0q7KtIj06lic1uMR6963ckj+sQTBNjh9Sz5hCVFVo8Xt5Q8Uzszeta4EexFWn1/1F/OXcdSUsAmrr1XVTO1UVTRj+L0xa6q5wul6U+0Z0PBLivf5l9qG3Tdfkt4JHpefEfjPT0p7LPb6RZa1e1QwKioyQ1oGFJMI7BZQPIVHiDXS1jAGlHGjUbS1DjXkmZWtIUFSXsCJbVgpRrEwWYjdXUNc0HpMoeB844vXyq9Jd4zbz1GPzTxyzvHbB8TMH887q/eCqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11-04 17:52, Pratyush Yadav wrote:
> On Tue, Nov 03 2026, David Matlack wrote:
> 
> > Allow userspace to pass O_RDONLY in struct liveupdate_shmem_retrieve_arg
> > to retrieve a tmpfs file read-only.
> >
> > open() requires write access for O_TMPFILE, so create the file writable
> > like before, then reopen it read-only with dentry_open() using the flags
> > of the writable file, which file_open_root() normalized, and drop the
> > writable file. Like open(), which grants the requested access to a new
> > file regardless of its mode, don't check permission for the read-only
> > open.
> >
> > Retrieving a file read-only allows a restored binary to be executed
> > before the session is finished. LUO keeps the retrieved file open until
> > then, and executing a binary that is open for writing fails with
> > -ETXTBSY. Being able to execute restored binaries right away matters
> > when they are needed to finish restoring the system, e.g. to bring up
> > the services that retrieve and finish the remaining sessions.
> 
> Can't you put all your binaries in a separate session, retrieve it as
> the very first thing, and then finish the session? Then you can execute
> those and retrieve all the other sessions.

This is a good workaround. I am not opposed to this patch for 
completeness of functionality, but if we decide to keep it, perhaps it 
should simply be squashed into an earlier patch. The current diffstat
looks bad, as it mostly deletes code that was introduced earlier in this 
series.

In any case, given Pratyush's suggestion, we could also drop it.

> 
> Why do we need to support this in the kernel?
> 
> Also, please put the motivation as on the top-ish of the commit message,
> and the mechanics later. For example, your second paragraph should
> likely come below this one.
> 
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Pasha

