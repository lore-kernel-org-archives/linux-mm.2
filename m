Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBA4606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=BG8PB+uy
Received: by kanga.kvack.org (Postfix)
	id 1392A6B0815; Wed, 21 Oct 2026 21:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA736B0816; Wed, 21 Oct 2026 21:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F42246B0817; Wed, 21 Oct 2026 21:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6A646B0815
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:45:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31BCFC0653
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:45:00 +0000 (UTC)
X-FDA: 85348568760.06.BEAD117
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id C38C420002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:44:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BG8PB+uy;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792633498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS+EicQQq2YSXAcv/CHPjd9x8RnM4wjQksgtpzHAKuY=;
	b=r9l2vw2Y848LtCIahIHdTcAeyUiemJ3ookCiL3BawFZUcdv3vY007N5IGUosHA+eqpXws6
	BKpUwvMS4DgDfiie4C9Lz3DR9y4snystwbzJOhNah3FRml8tgn29j7GOzayClmAT//whap
	YQUfiDRzmckE9NHSvbD+eWqSghEGcuM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BG8PB+uy;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792633498;
	b=eRAq8maeLT7n55PUhb/vji3FTcjIV4e1l31EZ9dx656PtbQgjyKYknvfYZGZNeDZIB4rh9
	vr9BiLWN0XBHME5VV4qdD2U0lOt58pIviLBLx3120KAWGZBHNVA16/TOxZp2hMl4adCLTy
	51YY3eQnO2dE6YmCeLadku3m/rC/2DY=
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5eaeb7fdda2so1177038e0c.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792633497; x=1793238297; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LS+EicQQq2YSXAcv/CHPjd9x8RnM4wjQksgtpzHAKuY=;
        b=BG8PB+uy/ff16mT6cmKpeZk9rphOXS8+JZgXGWrBNKA28dJnTos/TSsFN9/WWMN/0i
         bJBC9P3DGK2K5QEj1rJWQmAcpoG9UIz8rqvKEoGCYVCypXQdDPx2vqC6mPIPk3/vzhsL
         lVxqjDOXWSEtvaVUNr5U3qVMTeboq3rzTiL/vJvtwEYoWpinLIQA89dxin3I49TR3Uvq
         VAqjOUFM4qgHXsDO+WPAF0K3qBUX6WZL5CLbF0wF/oF+N/Pdmt7s/EM2sGG+UtFxM7gw
         0R+u1c4M1ej3DRLLHjLt/k7FXcFmaZnLUdx8b8SmUu2rMz8j7fD5mRrhLyrH41QpBiHQ
         IKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792633497; x=1793238297;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LS+EicQQq2YSXAcv/CHPjd9x8RnM4wjQksgtpzHAKuY=;
        b=PTx4JYRga+h87LxMcOhh8XDtdogn42k3fUUD1QbhPQ7mHAtSrSEdtsaiQS41QSlVo7
         cs+sQ1SJpjK5bTP/CG7qPSkRKwyc70K+uyEaik3bqzRbi9En5nfNa8YzvV6nGWCUlhp9
         VgDc94sa+Rry9IKKctZDUHrbkIwBIoPBiTKMUBLTN93wQWsohaAB17g1AGJS3GW+eRcg
         DVDqpTp336/ezo4nU3/jwVCN5HpxVHpzneyffdHA0i6UoaKh5skUqmH6+uaH1SmUS1ru
         ukaofa8UX8PXO3gfxPi+DppnUo1ft9zu9EXS6ztN/rm5THDkjNgni0WR1+W/Iu0PvSpL
         XTag==
X-Forwarded-Encrypted: i=1; AKwUvByZqRNQrsEmbSH00yNrxBVccf21/96OmztUb6RHetIJB0prpgVqK1yILeTT/kn685OdsIo1dXsfOA==@kvack.org
X-Gm-Message-State: AFq9FYIA9A0jjsW9EcwgjpJIkXsb2G8uSQztJ/5xGp023BsHwL9XTziw
	NJxAno3JvLXB6mE5VBeERZwjR7WHhw8c+q4ZYuvyRYLlDPEK8cEDVCsODte39A7H9e0=
X-Gm-Gg: AYBFou1oM6RBxONHQUEO0+yYuKr1SyqIuC8Dpgnxuue0jFPNOn5OpxkV6nwZK2ZGP9E
	qGKRySLzBQWFtZFtfgZazuvKn7uah3T85ln7quhqVzvLifYQxQX4RpsU4JucLkkiyik02UeWSnx
	x6JOkqoU2tSaPA75UzjJ3GfrumWLmkz2V5VB/Zl/VROhsZPHE2/3XANX2vzjv9ym4wI1tbYHxfJ
	mD2NyhfG4lvF4504IDnPEcsd1bOpG4+Pr0iWfaeHmDQgkaJw9T142VF+OA2Y3VAJUAuOpSsLkjm
	bLn+oAaeWHogEpZrPaomu6jfpn/6As3eMc8rOMOIZHxFFntiGEnTnOJmGPr1mwYB5t42LaNVAeY
	VaYY60Dq/PTFPbHjRh99EsAPrueIO94iVavDLk8cWLTKoVn9LAKXRL7OAm8w1SqC6iPpj0DV4rZ
	L9iWP6b7Qdb226s5yEVmGM4tVehyQlW8I6UPspkoC0f34CculZnxsowfgNFflIxTcCIrkJgjIMy
	Cgqse7K3/8jJPlTvRgAJ+dEm3Hk1pRyGdQMqXS+M0sONK0+M8ik6q2UAVOnSmgjlsMSdK2IaJjz
	VrCLiVF8u63w9+YiTrubM9/IhpLTWEHecCZSv05Ydsb8ENdX2KdwxfylyelObBj6+wTEkCVELrb
	fXg==
X-Received: by 2002:a05:6102:418a:b0:7be:25d4:7ff0 with SMTP id ada2fe7eead31-7cc92469ecdmr1660230137.4.1792633497085;
        Wed, 21 Oct 2026 18:44:57 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-990d104017bsm4933026241.4.2026.10.21.18.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:44:55 -0700 (PDT)
Date: Wed, 21 Oct 2026 21:44:55 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	kexec@lists.infradead.org, graf@amazon.com
Subject: Re: [PATCH v2 1/2] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
 to freeze sessions early
Message-ID: <atlql8V0YcXGRxS3@google.com>
References: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
 <20261020144710.4154339-2-pasha.tatashin@soleen.com>
 <2vxz4iefgy36.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz4iefgy36.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C38C420002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xdw8mcwcm88wcs58y5zjezz3j7joy8js
X-HE-Tag: 1792633498-136491
X-HE-Meta: U2FsdGVkX186Q3JxlYR6X4xUQFfeg8CP50yQmX3WZpFisMzuBTt6aBv2a/8XAhls90g0f4OI2yg0637GIgJ69KTQTXfpO1XX2+E36IDQa/5wddyFDhiPI4tpqOLAdQ589nI7FaPmVZWEFqZMFqxb1w0F0q6uzv2vCz3aiuSp4ymJCAuB1tLjgWHfjoHHDpxMDE9rTEm23tV3a4TJa2nN/+E06CbHaFIgj411TH1tFKDuwhPW0+1AtQzS9xvwzhJnyNOlOh9br/JyhUCcG+hQFARff73wYsuo41VLxmKu7xzsphWY6WvpfwgovDnoVVRn47zdMudgg5AAVjQbDqPRPNsZimrfjaQeq1P8ip7kVNZGP8ZLeaFy6Lrabw2fqVycFH9cqbQj6DikY4ryKd5YfyGWHM7H5Duveml+j7b1HIkBnqR0o0bmLY/pPqva5hrXmmQdyUSoEnQ6J3hgyPNQdqvPfe+Q1NvPktMRsypM8wQYLNNgfASjv+HQVvdLfiGKWbr/4UPLs2AORFeoYOtSha4TVF0plsRmGH2F9CtaMM9K6oIkEMrFCYei1lZtKIcw8vn6X+sCr2pPxwGNa7zMpF6AntebpvxT2KjDcjV3JqjLXwfsUhaLMcVV+o0cDbmy+HhhLNFRvGjRH5PRNrnkM9nT3yVnAYEcQb2Ryhjgos3wewytO2y8qNnh0RsTdBsxfJmnhL8RSUA53/Oilw1yQyUqeRKFatJLYaV2uodglAC0PozSsiLo1jjFZolyx/nyjK7ZuwIgLxsNFoFVxEJPzV+BqhC0gYRuakePnTKxSYTKkdHYn4wJJ244n1BxHDuf1+lG1+E1GnCtYpasAdTlkz2igkPBuAGCx6p4GztUxJE85kv7+FR6yJO14PSZCrXltIsuBRD0H3/yZ43wm8iGVKQrvCN1VJYgNiCANVzCQGydK0FRlwoOz065qo3fLKl2Iby2j00krLq2+2fORO5
 XN3yJ/ZK
 WiJJup9FehboZFMBMnSRdhL9QBfzXY/qzof89aq1GF1qYn635jq4HnDwNWExWc8YctnSrt1Av9vXh1EjOMZaIUqyHx0ZMBaIIOYGh9oEC+dBkmb2Ui6IZaw5mx54BaRvo7mUT7JE7poJrb7AAWkBDn2NgkUrrC6qVmrESuviLhHXplZHgd3nYEqDSKzY24ac0JNsX58ZwsHlop9Yhwj+akjTHguLvm28mbk2SVn10kXtLbqFDOVuipKi8HEu7Yb+pBCz75WQ0F2r5qzLECWtL42Co0UOj9kKDm3zMQxHZDYC6dC5U9lP6HUmEG33se4OoKvzT3tk5maFMjgAP1ez9vO4gaPNs8LtJjiSZ4u1R3ByZnW8py3BY7ezXqmaguiFxRzT99tQ4WNJJ5nHnzSrOFvr8vhygAkmqLhFLLBz+Ds4AlDRAEPJUZLjm6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-21 12:14, Pratyush Yadav wrote:
> On Tue, Oct 20 2026, Pasha Tatashin wrote:
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
> > @@ -218,18 +219,33 @@ static int luo_session_finish_one(struct luo_session *session)
> >  	return luo_file_finish(&session->file_set);
> >  }
> >  
> > -static void luo_session_unfreeze_one(struct luo_session *session,
> > -				     struct luo_session_ser *ser)
> > +static void luo_session_unserialize_one(struct luo_session *session,
> > +					struct luo_session_ser *ser)
> >  {
> >  	guard(mutex)(&session->mutex);
> > -	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
> > +	if (!session->frozen)
> > +		luo_file_unfreeze(&session->file_set);
> 
> "Wait, this looks wrong. If session is not frozen then unfreeze it?
> Should be the other way round, right?"
> 
> This was my first reaction until I realized that you only unfreeze
> _automatically_ frozen sessions. User-frozen sessions stay frozen. Which
> makes sense, but is not obvious at all.
> 
> Perhaps rename this to session->user_frozen and add a comment here?
> 
> With that fixed, feel free to add
> 
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thank you, I am going to send out a new version soon.

Pasha

> 
> > +	memset(ser, 0, sizeof(*ser));
> >  }
> >  
> > -static int luo_session_freeze_one(struct luo_session *session,
> > -				  struct luo_session_ser *ser)
> > +static int luo_session_serialize_one(struct luo_session *session,
> > +				     struct luo_session_ser *ser)
> >  {
> > +	int err;
> > +
> >  	guard(mutex)(&session->mutex);
> > -	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
> > +	if (!session->frozen) {
> > +		err = luo_file_freeze(&session->file_set);
> > +		if (err)
> > +			return err;
> > +	}
> > +
> > +	strscpy(ser->name, session->name, sizeof(ser->name));
> > +	ser->file_set_ser.count = session->file_set.count;
> > +	ser->file_set_ser.files =
> > +		kho_block_set_head_pa(&session->file_set.block_set);
> > +
> > +	return 0;
> >  }
> >  
> >  static int luo_session_release(struct inode *inodep, struct file *filep)
> [...]
> > @@ -267,6 +286,9 @@ static int luo_session_preserve_fd(struct luo_session *session,
> >  	int err;
> >  
> >  	guard(mutex)(&session->mutex);
> > +	if (session->frozen)
> > +		return -EBUSY;
> > +
> >  	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
> >  	if (err)
> >  		return err;
> > @@ -340,11 +362,40 @@ static int luo_session_get_name(struct luo_session *session,
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
> > +	err = luo_file_freeze(&session->file_set);
> > +	if (err)
> > +		return err;
> > +
> > +	err = luo_ucmd_respond(ucmd, sizeof(*argp));
> > +	if (err) {
> > +		luo_file_unfreeze(&session->file_set);
> > +		return err;
> > +	}
> > +
> > +	session->frozen = true;
> > +
> > +	return 0;
> > +}
> > +
> >  union ucmd_buffer {
> >  	struct liveupdate_session_finish finish;
> >  	struct liveupdate_session_preserve_fd preserve;
> >  	struct liveupdate_session_retrieve_fd retrieve;
> >  	struct liveupdate_session_get_name get_name;
> > +	struct liveupdate_session_freeze freeze;
> >  };
> >  
> >  /* Type of sessions the ioctl applies to. */
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

