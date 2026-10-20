Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF70606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=OXoj8rVv
Received: by kanga.kvack.org (Postfix)
	id 64F5D6B04DB; Tue, 20 Oct 2026 10:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600446B04DC; Tue, 20 Oct 2026 10:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE2C6B04DD; Tue, 20 Oct 2026 10:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2709E6B04DB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:30:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31F751A021A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:30:13 +0000 (UTC)
X-FDA: 85343239506.29.4EB9F25
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4B08580007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:30:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OXoj8rVv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792506611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xf7TkZF3OBqfOdq3p0Xj300grOV6/XXUYozCmNJzyro=;
	b=e2CedOMFi4ZtFozndpu0ixccw+ggKGdNnQbo/Jga1dITP7IA3sqRYDPcBJQuURsvRaunZU
	/5rhMhDFgVLLe6SSYLoMPU/PBiZM8r5S9udu6qw7IvkV6Hish0QkVli5ojci6mfKdQj3eC
	m5/u9Hu+BahzVM/AjkYpKU4p5twpPhk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OXoj8rVv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792506611;
	b=ZTMXC7X8ov2BySVfyqoX178FK8IaUAPDIJM6HxSLD31dcbz54Fp0Ngnh+lfN2nUi5R9XlG
	lc0IpfjgTVBTSROVj3BkKi0NTFzECbJF2xkZ8Odu1Dx/PDeSAjv629uY/soOEmpI7Yxdja
	3F1OMB1q/OYOw5q/wFYqiY/k2iuD1oo=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5ead32bc7d8so1252822e0c.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792506610; x=1793111410; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xf7TkZF3OBqfOdq3p0Xj300grOV6/XXUYozCmNJzyro=;
        b=OXoj8rVvRje4COsGZbDg3apahW9TGZL9iaMAO7MK8J3tevPtlw/C/A/wwS1Uz4Fqif
         p1z17b6zPq52kGx5MK0gp/Ik0mcQIpwfhnfZ4PhtW03q8dYfiAgGGqbJdTp7iWX9JX3h
         Lf7dVw0BNOSmr3KfflR8o77in9a1TBfWNR9nUAvFnNp+oISxdGFXMnzrw43PbbpxxdB3
         woA/A2JnX/zQaUCGjh4iT5EvXu4Xq18QWCLNqLjKi4B6z0kAPX9Zud4gkekLCF6ro9nV
         v0oNVQ8ROfOXwu5ou98xndzr3uDLm+JfvwxupwmUyXu2Nk8AadY7/xHMFWoyjbcrwa1z
         tv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792506610; x=1793111410;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xf7TkZF3OBqfOdq3p0Xj300grOV6/XXUYozCmNJzyro=;
        b=gDtEI7SrvufSfwM+Y69fIq4/xQp/SRv5tGOVDVM4sZWHcf6kZujEYi03Moh2AQfruC
         yZm6JFg1yYgE/o8XTeYQSIz/P8A9Yl657vWkxLMaTdievNvSeKdDGVng6IXbC6eLeJt0
         E3D376dT02Cxidnfe9pYnbKb6YbBSKLbET2KhKCq8O8aWaQUlySrgFH5NCvOXDwCmQux
         +f4tm8R4R49GAGmWIOGY2SYqJeUzhHzDle8VErBt2nMfaN5I47smqmYvkz3ctboaXhRH
         X9M3WfdOJpZZr3FEvmJuo92RO/m55GsRmJnsz7AgDU9/mqrUmXpz1Zul4I+YSVM99b/4
         Kypg==
X-Forwarded-Encrypted: i=1; AKwUvBwW3nVR+gID2oql84VAM10NGwc0DeBJXQ7qzRE868d1Je5m00+1XkQqXZqpNSJINLnLfrPn9uCgvw==@kvack.org
X-Gm-Message-State: AFq9FYKSN91Ima1sf75fdz+QejMyspfwdSuY7uh6XnORikyc2Zcyc2NQ
	bo+ojQW9Y5tI5DTR+qsNGCYYIO44Os/mYs88x2c6XQB8OqCmH0fFpckNy2Dg0Im2O40=
X-Gm-Gg: AYBFou2tmhpdH774sXYK5qDtj+fAayUIJYmru6xnyNO4mK9oOyN6N31ap1M44Ston4k
	VlrGLVgpq4aXeExYfIsT2E/n+DRLTrBp1j7n53K9HsGdm4aLgdWNDWxCPqd+0IWXnO4PdJY5Xh9
	v33gZ+PAurMVyMJnO7265xMEkVKygEcbrWsrbfR9CZCRLRXE+vN2BQ6Aeaf25sFYBq6F5OkaF/4
	8WZTLDGcb5xBnI5xU7LQ6VVRFAApMj+aONX/8IcU/nmFIfaKRl7tBQ1QGt0k0hPlFdPQdT8VU6A
	ydrTNdb1nDAXQ62MfzOWYJdrZJV6JClS6jlk+Qf3QdOftIke42m/mv9gunY8dRjXSGMApFUADpj
	Eq4ll3zim7AptuJ6A9pZBX2AT0ma9bYLPB0DO5syUW89hoAVvMG1e48Aj9B4nJEA8D/P1+PJ/J3
	T4kS3YY+A8fvD2fX19vYFovk6sahlY9gQ1tBrZTdgSsIfqhYiQJ1AyxMd0rkyEKbl1wexPbxlNX
	MabuFx5258Qadj/rJRWFYFpky31Ha9N1Sm7veNz4CrSTh7Y0e46Fog80Xc/2m34Yoe4L2e7KqI=
X-Received: by 2002:a05:6122:20a4:b0:5ea:cc3c:9449 with SMTP id 71dfb90a1353d-5eacc3c9891mr1844327e0c.19.1792506610182;
        Tue, 20 Oct 2026 07:30:10 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eaca7cc59asm5934172e0c.5.2026.10.20.07.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:30:09 -0700 (PDT)
Date: Tue, 20 Oct 2026 10:30:08 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	kexec@lists.infradead.org, graf@amazon.com
Subject: Re: [PATCH v1 1/7] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
 to freeze sessions early
Message-ID: <atd68E5_LA9bsfeV@google.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
 <20261015093816.2438942-2-pasha.tatashin@soleen.com>
 <2vxz8q3shboh.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz8q3shboh.fsf@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B08580007
X-Stat-Signature: zuwerxjw8dwnagz6mkdfm7tadgm4gz5t
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792506611-112566
X-HE-Meta: U2FsdGVkX184evhujG5x+IsYrrNI6+aWGKig7ovu535oBV/K0bwMdFHjgHxXqdO6W9qMCOW+NBQXIVlENMQwx42K4W61Zey9MCW9hilKhXmftsdI8Dv4HLa4bg2uKg8zWBD4o42MEzDKDmaylvbdgc3RxACYd+suB1F26EdIS9K1gWqgRC1FTh7c3D2HEXBUk+VvfJY5b/+lcg+7yPTIcOClZEbM5a8DQGB/MCtZRKzoA9LjdiQLx6NB3mnkcb/jOGHUXGooInz4Zp/nx/t5T4HxIt3nUGKF9OxahlcaJ1TGpT6/4MrhaxZKMalnbUzKqONptiE99iP7MefL2nWvBzS0IvZxFGez5HUpyg+k2qJRpEptW4LaL3qE0M9NUcZ+pLfVtCgucwU2NK4sIuANM/GC/7G+Vx7pGrskPJZBiReymWtobR8P0tdc+WRkOkk7IR3E6AxTEZGGFh3yui3uL0f8R+pksw9GhyRYbFzHhixxEtFezweFEdMypARrt9KOELkXPL+z8+ftpKSy/VUKfYB+lLSxsaTCa89EopCKLF1bykEG9U+p/GlAgxeF3QVNeyuJM/gBEAkVIT2fSY7xtkNoKF0J7jbIhwGSSD+ztSB7ewXINW61tu7WdwivxbEMokhlIex7b7XxdblLHxIcPSHeCJ6et/XpGnlBOX3TkdkBUzGcDshas8Qu6q5yEoZSoaVYTpo9LMBc+v/jdki86k8PgyypB2dZqAbJUoCk4FTmIdNuPUYbJARIAn/A/6gvmt7ITWHG6QcJWC3RXW1pq34cfIoMFFx+eaiusvPMn19AIQY8ixRv8E7G+NQnspAkKo+47ho+y7ZCIduSWUWuYohsg/OaNHEPutvXuenHbGBlqiqw3aF2NJNr5k/hj7FXZ5Yw8UzSCjfI2Mrpu7K4yQ/bCB74sCYlHq/cUWSjNkYlvZX/LlIilopW9JdXM0+ohXwi6GhwaaLvtDQMYz+
 ACbdIzpc
 7Z3vkR+yFM18FKfbViTbB/pDL25okD6LuVPzpmd1JT7foUtISPdsMhZL9sdqOBbsAWvbn/izLQqha5PzHzO9XYFE3BlGDzgqTmjwuVcMVAFfopwwTnDYd5Iy+0WBSabMV85xf9zkYBLFg3fh9dsRN8RNLKjFD3rYr6dOaPz41okof9aHWrzEgLnmVLEpK5wFwsTYokYxgaUbKicenaIRQ9buKnSHJwq7ymQyeCK5vb9iiVjd2B/xT3iAXAgZSjfDJNIhbbSerG0aOyEz1OBzwD3DhtdYhtX0i4/t1juO5I4GjayXFZ/OIfTslPLResk0MRWdOBTb7S0rOjt39b98Uz7JgxoX8ts4nRxJJAdUDuecvE8PsLLq55Tjou2ocj+bTa9QqxTaqnZYsoOTR5W1QHl9sn53UBVnzICoV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-20 13:08, Pratyush Yadav wrote:
> Hi,
> 
> On Thu, Oct 15 2026, Pasha Tatashin wrote:
> 
> > Currently, LUO sessions are frozen automatically only inside the
> > reboot(LINUX_REBOOT_CMD_KEXEC) pathway, where luo_session_serialize()
> > iterates through all outgoing sessions under global write locks and
> > freezes them serially during shutdown. Allowing userspace to decide when
> > to freeze a session once it is done with it (and to freeze multiple
> > sessions in parallel, since luo_session_freeze() only acquires the
> > per-session mutex) avoids postponing this work to kexec shutdown and
> > reduces blackout time.
> >
> > Introduce LIVEUPDATE_SESSION_FREEZE on session file descriptors to freeze
> > a session early. The ioctl runs .freeze() across all preserved files in the
> > session and serializes their metadata. Once frozen, no additional files can
> > be added to the session, and subsequent freeze calls return -EBUSY. Freeze
> > is only valid on outgoing sessions and returns -EINVAL on incoming ones.
> >
> > During kexec, sessions that were already frozen early are skipped, while
> > sessions that did not invoke this ioctl auto-freeze as before. If an
> > early-frozen session is released before kexec, its files are rolled back
> > via .unfreeze() before being unpreserved.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> [...]
> > @@ -487,8 +488,10 @@ int luo_file_freeze(struct luo_file_set *file_set,
> >  		file_ser->token = luo_file->token;
> >  	}
> >  
> > -	file_set_ser->count = file_set->count;
> > -	file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
> > +	if (file_set_ser) {
> > +		file_set_ser->count = file_set->count;
> > +		file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
> > +	}
> >  
> >  	return 0;
> >  
> > @@ -501,7 +504,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
> >  /**
> >   * luo_file_unfreeze - Unfreezes all files in a file_set and clear serialization
> >   * @file_set:     The file_set whose files are to be unfrozen.
> > - * @file_set_ser: Serialized file_set.
> > + * @file_set_ser: Serialized file_set, or %NULL if not serialized yet.
> >   *
> >   * This function rolls back the state of all files in a file_set after the
> >   * freeze phase has begun but must be aborted. It is the counterpart to
> > @@ -512,7 +515,8 @@ int luo_file_freeze(struct luo_file_set *file_set,
> >   * their respective .unfreeze() handler callbacks.
> >   *
> >   * Context: This is called when the live update is aborted during
> > - *          the reboot() syscall, after luo_file_freeze() has been called.
> > + *          the reboot() syscall, after luo_file_freeze() has been called,
> > + *          or when an early-frozen session is released before kexec.
> >   */
> >  void luo_file_unfreeze(struct luo_file_set *file_set,
> >  		       struct luo_file_set_ser *file_set_ser)
> > @@ -521,7 +525,8 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
> >  		return;
> >  
> >  	__luo_file_unfreeze(file_set, NULL);
> > -	memset(file_set_ser, 0, sizeof(*file_set_ser));
> > +	if (file_set_ser)
> > +		memset(file_set_ser, 0, sizeof(*file_set_ser));
> >  }
> >  
> >  /**
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> > index 64879ffe73781..b42369c3b1f30 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -64,6 +64,8 @@ struct luo_file_set {
> >   *              previous kernel) sessions.
> >   * @retrieved:  A boolean flag indicating whether this session has been
> >   *              retrieved by a consumer in the new kernel.
> > + * @frozen:     A boolean flag indicating whether this session has been
> > + *              frozen early from userspace.
> >   * @file_set:   A set of files that belong to this session.
> >   * @mutex:      protects fields in the luo_session.
> >   */
> > @@ -71,6 +73,7 @@ struct luo_session {
> >  	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> >  	struct list_head list;
> >  	bool retrieved;
> > +	bool frozen;
> >  	struct luo_file_set file_set;
> >  	struct mutex mutex;
> >  };
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> > index f48e9a4185f97..403906937bc0f 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -34,10 +34,11 @@
> >   * 1.  Creation: A userspace agent calls `luo_session_create()` to create a
> >   *     new, empty session and receives a file descriptor for it.
> >   *
> > - * 2.  Serialization: When the `reboot(LINUX_REBOOT_CMD_KEXEC)` syscall is
> > - *     made, `luo_session_serialize()` is called. It iterates through all
> > - *     active sessions and writes their metadata into a memory area preserved
> > - *     by KHO.
> > + * 2.  Freeze / Serialization: Sessions may be frozen early from userspace
> > + *     via `LIVEUPDATE_SESSION_FREEZE`. When the `reboot(LINUX_REBOOT_CMD_KEXEC)`
> > + *     syscall is made, `luo_session_serialize()` is called to freeze any
> > + *     remaining active sessions and write all session metadata into a memory
> > + *     area preserved by KHO.
> >   *
> >   * 3.  Deserialization (in new kernel): After kexec, `luo_session_deserialize()`
> >   *     runs, reading the serialized data and creating a list of `struct
> > @@ -222,6 +223,10 @@ static void luo_session_unfreeze_one(struct luo_session *session,
> >  				     struct luo_session_ser *ser)
> >  {
> >  	guard(mutex)(&session->mutex);
> > +	if (session->frozen) {
> > +		memset(&ser->file_set_ser, 0, sizeof(ser->file_set_ser));
> > +		return;
> > +	}
> >  	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
> >  }
> >  
> > @@ -229,6 +234,12 @@ static int luo_session_freeze_one(struct luo_session *session,
> >  				  struct luo_session_ser *ser)
> >  {
> >  	guard(mutex)(&session->mutex);
> > +	if (session->frozen) {
> > +		ser->file_set_ser.count = session->file_set.count;
> > +		ser->file_set_ser.files =
> > +			kho_block_set_head_pa(&session->file_set.block_set);
> > +		return 0;
> > +	}
> 
> This is getting messy. If early freeze, then you set the file_set_ser
> here, if late freeze, you set it in luo_file_freeze().
> 
> I think it is better to just set it here, and drop the code from
> luo_file_freeze() entirely.
> 
> Same for unfreeze.
> 
> Maybe also rename the function to make it clear it only runs for
> serialization? The core of serialization is done by luo_file_freeze().

Agreed, that is cleaner. In v2 I dropped struct luo_file_set_ser * from 
luo_file_freeze() and luo_file_unfreeze() completely, and renamed the 
session helpers to luo_session_serialize_one() / 
luo_session_unserialize_one() so all of struct luo_session_ser is 
populated and cleared there.

Pasha

> 
> >  	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
> >  }
> >  
> > @@ -249,8 +260,11 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
> >  		}
> >  		sh = &luo_session_global.incoming;
> >  	} else {
> > -		scoped_guard(mutex, &session->mutex)
> > +		scoped_guard(mutex, &session->mutex) {
> > +			if (session->frozen)
> > +				luo_file_unfreeze(&session->file_set, NULL);
> >  			luo_file_unpreserve_files(&session->file_set);
> > +		}
> >  		sh = &luo_session_global.outgoing;
> >  	}
> >  
> > @@ -267,6 +281,9 @@ static int luo_session_preserve_fd(struct luo_session *session,
> >  	int err;
> >  
> >  	guard(mutex)(&session->mutex);
> > +	if (session->frozen)
> > +		return -EBUSY;
> > +
> >  	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
> >  	if (err)
> >  		return err;
> > @@ -340,11 +357,34 @@ static int luo_session_get_name(struct luo_session *session,
> >  	return luo_ucmd_respond(ucmd, sizeof(*argp));
> >  }
> >  
> > +static int luo_session_freeze(struct luo_session *session,
> > +			      struct luo_ucmd *ucmd)
> > +{
> > +	struct liveupdate_session_freeze *argp = ucmd->cmd;
> > +	int err;
> > +
> > +	if (argp->reserved)
> > +		return -EINVAL;
> > +
> > +	guard(mutex)(&session->mutex);
> > +	if (session->frozen)
> > +		return -EBUSY;
> > +
> > +	err = luo_file_freeze(&session->file_set, NULL);
> > +	if (err)
> > +		return err;
> > +
> > +	session->frozen = true;
> > +
> > +	return luo_ucmd_respond(ucmd, sizeof(*argp));
> > +}
> > +
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

